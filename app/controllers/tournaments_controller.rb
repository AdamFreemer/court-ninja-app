class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[status tournament_status
    administration display results submit_scores team_scores_update 
    process_round edit update destroy admin_connection update_scores set_stale]
  before_action :set_display, only: %i[display]
  before_action :round_two_generated, only: %i[administration]
  before_action :current_set_players, only: %i[display status]

  def index
    # dashboards/index
    redirect_to root_path
  end

  def new
    @type = params[:type]
    @available_players =
      if @type == 'adhoc'
        []
      elsif current_user&.is_coach?
        players = current_user.teams_coached.map(&:players)
        players.flatten!.sort_by(&:last_name)
      else
        User.where(is_ghost_player: false).order(:last_name)
      end
    @tournament = Tournament.new
    @tournament_times = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
    @break_times = [0.12, 0.5, 1, 1.5, 2.0]

    @match_times = [["30 seconds", 30], ["1 minute", 60], ["2 minutes", 120], ["3 minutes", 180], ["4 minutes", 240], ["5 minutes", 300], 
                    ["6 minutes", 360], ["7 minutes", 420], ["8 minutes", 480], ["9 minutes", 540], ["10 minutes", 600]]
    @pre_match_times = [["5 seconds", 5], ["30 seconds", 30], ["1.0 minute", 60], ["1.5 minutes", 90], ["2.0 minutes", 120]]
    @tournament_configured = !@tournament.rounds_configured.empty?
  end

  def edit
    @available_players =
      if @tournament.adhoc
        []
      elsif current_user&.is_coach?
        players = current_user.teams_coached.map(&:players)
        players.flatten!.sort_by(&:last_name)
      else
        User.where(is_ghost_player: false).order(:last_name)
      end
    @tournament_configured = !@tournament.rounds_configured.empty?
    @player_names = @tournament.users.map(&:name_abbreviated)
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.created_by = current_user
    @tournament.timer_time = @tournament.pre_match_time + @tournament.match_time # set default time to be display

    set_create_update(params)
    if @tournament.save
      @tournament.associate_players
      if @tournament.generate
        @tournament.update(current_round: 1)
        # redirect to court #x if more than 1 court (other courts will be opened from front end isNew method)
        court_to_open = @tournament.courts
        redirect_to display_url(@tournament, court_to_open), notice: 'Tournament was successfully created.'
      else
        redirect_to tournaments_url
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    cleaned_up_params = tournament_params
    cleaned_up_params[:players] = cleaned_up_params[:players].compact_blank.map { |i| Integer(i, 10) } if @tournament.adhoc == false

    if @tournament.update(cleaned_up_params)
      @tournament.associate_players
      if @tournament.rounds_configured.empty?
        if @tournament.generate
          @tournament.update(current_round: 1)
          redirect_to display_url(@tournament, 1), notice: 'Tournament updated and round one successfully created.'
        else
          redirect_to tournaments_path, notice: 'Tournament was successfully updated (no rounds created).'
        end
      else
        redirect_to display_url(@tournament, 1), notice: 'Tournament information updated.'
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: "Tournament was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def administration; end

  ##### non-CRUD views #######

  def results
    rounds = @tournament.rounds
    # show results
    players_gold = @tournament.player_ranking(rounds)[0]
    @players_gold_winner = @tournament.player_ranking(rounds)[0].first
    players_gold.shift
    @players_gold = players_gold
    @players_silver = @tournament.player_ranking(rounds)[1]
  end

  def display
    @all_scores_entered = @tournament.all_scores_entered_court_round(params[:court], @tournament.current_round)
    @team_size = @tournament.tournament_sets.first.tournament_teams.first.users.count
    @work_size = @tournament.tournament_sets.first.tournament_teams.third.users.count
    @row_columns = (@team_size * 2) + 1
    @court_number = params[:court].to_i
    @court_sets_round1 = @tournament.tournament_sets.where(court: @court_number, round: 1)
    @court_sets_round2 = @tournament.tournament_sets.where(court: @court_number, round: 2)
    @scores = Array(0..30)
    @current_court_match = @tournament.current_matches[@court_number.to_s]
    @court_name =
      if @court_number == 1
        @tournament.court_1_name
      elsif @court_number == 2
        @tournament.court_2_name
      elsif @court_number == 3
        @tournament.court_3_name
      elsif @court_number == 4
        @tournament.court_4_name
      else
        ''
      end
  end

  ##### api endpoints ########

  def submit_scores
    message = ''
    status = ''
    tournament_set = { round: @tournament.current_round, court: params[:court], current_court_match: params[:current_court_match], scores: params[:scores] }
    if params[:round].to_i != @tournament.current_round
      # when the round was updated on one court but the other (one submitted) hasn't refreshed yet
      message = "<p>Alert!</p> Other Court submitted round. Page updated to round ##{@tournament.current_round}."
      status = 'new-round'
    elsif params[:function] == 'round' && @tournament.rounds_finalized.include?(@tournament.current_round)
      if @tournament.current_round == @tournament.rounds_finalized.last # tournament is over, shouldn't be getting here
        @tournament.update!(tournament_completed: true)
        message = "<p>Alert!</p> Tournament complete."
        status = 'new-round'
      else 
        message = "<p>Alert!</p> This round has already been processed."
        status = 'new-round'
      end
    elsif params[:function] == 'round'
      if @tournament.all_scores_entered_all_courts_round(@tournament.current_round.to_i) # check all courts for completed scoring
        @tournament.process_round(@tournament.current_round.to_i)
        message = '<p>Alert!</p> Round processed.'
        status = 'new-round'
      else
        message = '<p>Alert!</p> Not all courts in this tournament have completed scoring for this round.'
      end
    elsif params[:function] == 'scores'
      if @tournament.all_scores_entered_court_round(params[:court].to_i, @tournament.current_round.to_i) # check current court for completed scoring
        message = '<p>Alert!</p> All scores for this court have been entered.'
      else
        @tournament.update_scores(tournament_set, true)
      end
    end

    current_set_players # sets @current_set_players, below
    returned_scores = @tournament.tournament_teams.collect { |t| [t.id, t.score] }
    render json: {
      scores: returned_scores,
      current_set_players_court1: @current_set_players[0],
      current_set_players_court2: @current_set_players[1],
      current_round: @tournament.current_round,
      timer_time: @tournament.timer_time,
      break_time: @tournament.pre_match_time,
      is_completed: @tournament.tournament_completed,
      timer: @tournament.created_at.to_i,
      admin_views_count: @tournament.admin_views.count,
      current_court_match: @tournament.current_matches[params[:court]],
      all_scores_entered: @tournament.all_scores_entered_court_round(params[:court], @tournament.current_round),
      message: message,
      status: status
    }
  end

  def status
    @tournament.status_process_admin_views(params[:timestamp])
    scores = @tournament.tournament_teams.collect { |t| [t.id, t.score] }
    render json: {
      scores: scores,
      current_set_players_court1: @current_set_players[0],
      current_set_players_court2: @current_set_players[1],
      current_round: @tournament.current_round,
      timer_time: @tournament.timer_time,
      break_time: @tournament.pre_match_time,
      is_completed: @tournament.tournament_completed,
      is_new: @tournament.is_new,
      courts: @tournament.courts,
      timer: @tournament.created_at.to_i,
      current_court_match: @tournament.current_matches[params[:court_number].to_s]
    }
  end

  def update_scores
    message = "Alert: Scores updated."
    status = ''
    tournament_set = { round: params[:round], court: params[:court], current_court_match: params[:current_court_match], scores: params[:scores] }
    @tournament.update_scores(tournament_set, false)

    render json: {
      message: message,
      status: status
    }
  end

  def set_stale
    @tournament.update!(is_new: false)
  end

  def team_scores_update
    score_date = request.params['score_data']
    TournamentTeam.score_update(score_date)
    @tournament.update_current_set(score_date)
    @tournament.update!(timer_state: "run")
    render json: {}
  end



  def admin_connection
    # If timer is pausing / stopping, set time to current time on admin page
    # If timer is resetting, set time to stored break time on server
    # TODO: refactor number types
    if params[:state] == 'sync'
      @tournament.process_admin_view(params[:view])
    elsif params[:state] == "stop"
      timer_state = 'stop'
      timer_time = params[:time]
    elsif params[:state] == "reset"
      timer_state = 'stop'
      timer_time = (@tournament.pre_match_time + @tournament.match_time).to_i
    else
      timer_time = params[:time]
      timer_state = params[:state]
    end
    @tournament.update(timer_state: timer_state, timer_time: timer_time) unless params[:state] == 'sync'

    render json: {
      timer_state: @tournament.timer_state,
      timer_time: @tournament.timer_time,
      current_view: @tournament.admin_view_current
    }
  end

  def current_round_calc(current_round, total_rounds)
    if current_round == total_rounds
      current_round
    elsif total_rounds > current_round
      current_round + 1
    end
  end

  private

  def tournament_status
    return true if @tournament.rounds_finalized.count == @tournament.rounds

    false
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_tournament
    @tournament = Tournament.find(params[:id])
    @match_times = [["30 seconds", 30], ["1 minute", 60], ["2 minutes", 120], ["3 minutes", 180], ["4 minutes", 240], ["5 minutes", 300], 
    ["6 minutes", 360], ["7 minutes", 420], ["8 minutes", 480], ["9 minutes", 540], ["10 minutes", 600]]
    @pre_match_times = [["5 seconds", 5], ["30 seconds", 30], ["1.0 minute", 60], ["1.5 minutes", 90], ["2.0 minutes", 120]]
  end

  def set_display
    @current_set = @tournament.current_set
    @round = @tournament.current_round
  end

  def current_set_players
    @current_set_players = []
    # binding.pry

    teams = @tournament.tournament_sets.find_by(number: @tournament.current_matches['1'], court: 1, round: @tournament.current_round).tournament_teams.order(:number)
    user_ids = teams.map { |team| team.users.map(&:id) }
    names_abbreviated = teams.map { |team| team.users.map(&:name_abbreviated) }
    names_initials = teams.map { |team| team.users.map(&:initials) }
    picture = teams.map { |team| team.users.map { |user| user.profile_picture.attached? ? url_for(user.profile_picture) : '' } }
    current_set_players = user_ids.zip(names_abbreviated, names_initials, picture)

    @current_set_players[0] = current_set_players.map { |team| [team.map(&:first).compact, team.map(&:second).compact, team.map(&:third).compact] }

    # TODO: this (below) needs to expand for higher court counts
    return unless @tournament.courts > 1

    teams = @tournament.tournament_sets.find_by(number: @tournament.current_matches['2'], court: 2, round: @tournament.current_round).tournament_teams.order(:number)
    user_ids = teams.map { |team| team.users.map(&:id) }
    names_abbreviated = teams.map { |team| team.users.map(&:name_abbreviated) }
    names_initials = teams.map { |team| team.users.map(&:initials) }
    picture = teams.map { |team| team.users.map { |user| user.profile_picture.attached? ? url_for(user.profile_picture) : '' } }
    current_set_players = user_ids.zip(names_abbreviated, names_initials, picture)
    @current_set_players[1] = current_set_players.map { |team| [team.map(&:first).compact, team.map(&:second).compact, team.map(&:third).compact] }
  end

  def set_create_update(params)
    if params[:tournament][:adhoc] == 'true'
      create_adhoc_players(params[:tournament])
    else
      @tournament.players = params[:tournament][:players].reject(&:blank?).map(&:to_i) unless params[:tournament][:players].nil?
    end
  end

  def create_adhoc_players(tournament_params)
    player_nick_names = []
    player_ids = []
    tournament_params.each do |key, value|
      player_nick_names << value if key.include?('player') && value.length.positive?
    end

    player_nick_names.each do |player_nick_name|
      player = User.create!(adhoc: true, email: "#{random_email}@gmail.com", nick_name: player_nick_name, password: 'password', password_confirmation: 'password')
      player_ids << player.id
    end

    @tournament.assign_attributes(players: player_ids, adhoc: true)
  end

  def round_two_generated
    @round_two_generated = if Tournament.find(params[:id]).tournament_sets.where(round: 2).count.positive?
                             true
                           else
                             false
                           end
  end

  def random_email
    reg = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...50).map { reg[rand(reg.length)] }.join
  end

  # Only allow a list of trusted parameters through.
  def tournament_params
    params.fetch(:tournament).permit(
      :name, :address1, :address2, :city, :state, :zip, :date, :rounds, :team_size, :court_side_a_name, :court_side_b_name,
      :rounds_configured, :rounds_finalized, :court_names, :tournament_time, :break_time, :current_set, :match_time, :pre_match_time,
      :court_1_name, :court_2_name, :court_3_name, :court_4_name, :court_5_name, :court_6_name, players: []
    )
  end
end
