class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[status tournament_status
    administration display results submit_scores team_scores_update
    process_round edit update destroy admin_connection update_scores set_stale]
  before_action :set_display, only: %i[display]
  before_action :round_two_generated, only: %i[administration]
  before_action :current_set_players, only: %i[status]
  before_action :check_subscription, unless: :skip_subscription_check?

  def index
    @tournaments = Tournament.all.order(created_at: :desc)
    if current_user.is_admin?
      @tournaments
    else
      @tournaments = @tournaments.where(created_by_id: current_user.id)
    end
  end

  def display
    redirect_to results_tournament_path(@tournament) if @tournament.tournament_completed

    # current_match = 0 is set when all scores entered
    current_set_players unless @tournament.current_match == 0

    @all_scores_entered = @tournament.all_scores_entered?
    @team_size = @tournament.tournament_sets.first.tournament_teams.first.users.count
    @work_size = @tournament.tournament_sets.first.tournament_teams.third.users.count
    @row_columns = (@team_size * 2) + 1
    @court_number = params[:court].to_i

    @court_visibility = {
      court1: 'block',
      court2: @tournament.courts > 1 ? 'block' : 'none',
      court3: @tournament.courts > 2 ? 'block' : 'none',
      court4: @tournament.courts > 3 ? 'block' : 'none'
    }

    @court_sets_court1 = @tournament.tournament_sets.where(court: 1, round: 1)
    @court_sets_court2 = @tournament.tournament_sets.where(court: 2, round: 1)
    @court_sets_court3 = @tournament.tournament_sets.where(court: 3, round: 1)
    @court_sets_court4 = @tournament.tournament_sets.where(court: 4, round: 1)

    @scores = Array(0..30)
    @current_match = @tournament.current_match
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

  def new
    one_off_players = current_user.players.where(is_one_off: true).where('created_at > ?', 2.days.ago).order(last_name: :asc)
    team_players = current_user.players.where(is_one_off: false).order(last_name: :asc)
    @teams = Team.where(coach_id: current_user.id)

    @available_players = one_off_players + team_players
    @tournament = Tournament.new
    @tournament_times = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
    @break_times = [0.12, 0.5, 1, 1.5, 2.0]

    @match_times = [["30 seconds", 30], ["1 minute", 60], ["2 minutes", 120], ["3 minutes", 180], ["4 minutes", 240], ["5 minutes", 300],
                    ["6 minutes", 360], ["7 minutes", 420], ["8 minutes", 480], ["9 minutes", 540], ["10 minutes", 600]]
    @pre_match_times = [["None", 0], ["5 seconds", 5], ["30 seconds", 30], ["1.0 minute", 60], ["1.5 minutes", 90], ["2.0 minutes", 120]]
    @tournament_configured = !@tournament.rounds_configured.empty?
  end

  def edit
    @teams = Team.where(coach_id: current_user.id)
    @available_players = current_user.players
    @tournament_configured = !@tournament.rounds_configured.empty?
    @player_names = @tournament.users.map(&:name_abbreviated)
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.created_by = current_user
    @tournament.timer_time = @tournament.pre_match_time + @tournament.match_time # set default time to be display
    @teams = Team.where(coach_id: current_user.id)

    set_create_update(params)
    if @tournament.save
      @tournament.associate_players
      if @tournament.generate
        @tournament.update(current_round: 1)
        # redirect to court #x if more than 1 court (other courts will be opened from front end isNew method)
        court_to_open = @tournament.courts
        redirect_to display_path(@tournament.id, 1), notice: 'Tournament was successfully created.'
      else
        redirect_to tournaments_path
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @teams = Team.where(coach_id: current_user.id)
    cleaned_up_params = tournament_params
    cleaned_up_params[:players] = cleaned_up_params[:players].compact_blank.map { |i| Integer(i, 10) } if @tournament.adhoc == false

    if @tournament.update(cleaned_up_params)
      @tournament.associate_players
      if @tournament.rounds_configured.empty?
        if @tournament.generate
          @tournament.update(current_round: 1)
          redirect_to tournaments_path, notice: 'Tournament updated and round one successfully created.'
        else
          redirect_to tournaments_path, notice: 'Tournament was successfully updated (no rounds created).'
        end
      else
        redirect_to tournaments_path, notice: 'Tournament information updated.'
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to tournaments_path, notice: 'Tournament was successfully deleted.', status: 303 }
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

    @court_sets_court1 = @tournament.tournament_sets.where(court: 1, round: 1)
    @court_sets_court2 = @tournament.tournament_sets.where(court: 2, round: 1)
    @court_sets_court3 = @tournament.tournament_sets.where(court: 3, round: 1)
    @court_sets_court4 = @tournament.tournament_sets.where(court: 4, round: 1)

    @court_visibility = {
      court1: 'block',
      court2: @tournament.courts > 1 ? 'block' : 'none',
      court3: @tournament.courts > 2 ? 'block' : 'none',
      court4: @tournament.courts > 3 ? 'block' : 'none'
    }
  end

  ##### api endpoints ########

  def submit_scores
    message = ''
    status = ''
    score_payload = { current_match: params[:current_match], scores: params[:scores] }

    if params[:function] == 'round'
      # message = '<p>Alert!</p> Tournament scoring processed.'
      @tournament.process_round(@tournament.current_round.to_i)
      status = 'tournament-completed'
    else
      @tournament.update_scores(score_payload)
      # message = '<p>Alert!</p> Round processed.'
      status = 'tournament-running'
    end

    current_set_players # sets @current_set_players, below
    returned_scores = @tournament.tournament_teams.map { |t| [t.id, t.score] }
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
      current_match: @tournament.current_match,
      all_scores_entered: @tournament.all_scores_entered?,
      message: message,
      status: status
    }
  end

  def update_scores
    # for sidebar score updates
    message = "Alert: Scores updated."
    status = ''
    score_payload = { court: params[:court], current_match: params[:selected_match], scores: params[:scores] }
    @tournament.update_scores_sidebar(score_payload)

    render json: {
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
      current_match: @tournament.current_match
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
    @pre_match_times = [["None", 0], ["5 seconds", 5], ["30 seconds", 30], ["1.0 minute", 60], ["1.5 minutes", 90], ["2.0 minutes", 120]]
  end

  def set_display
    @current_set = @tournament.current_set
    @round = @tournament.current_round
  end

  def current_set_players
    @current_set_players = []
    teams = @tournament.tournament_sets.find_by(number: @tournament.current_match, court: 1, round: @tournament.current_round).tournament_teams.order(:number)
    user_ids = teams.map { |team| team.users.map(&:id) }
    names_abbreviated = teams.map { |team| team.users.map(&:name_abbreviated) }
    names_initials = teams.map { |team| team.users.map(&:initials) }
    picture = teams.map { |team| team.users.map { |user| user.profile_picture.attached? ? url_for(user.profile_picture) : '' } }
    current_set_players = user_ids.zip(names_abbreviated, names_initials, picture)
    @current_set_players[0] = current_set_players.map { |team| [team.map(&:first).compact, team.map(&:second).compact, team.map(&:third).compact] }

    # TODO: this (below) needs to expand for higher court counts
    return unless @tournament.courts > 1

    teams = @tournament.tournament_sets.find_by(number: @tournament.current_match, court: 2, round: @tournament.current_round).tournament_teams.order(:number)
    user_ids = teams.map { |team| team.users.map(&:id) }
    names_abbreviated = teams.map { |team| team.users.map(&:name_abbreviated) }
    names_initials = teams.map { |team| team.users.map(&:initials) }
    picture = teams.map { |team| team.users.map { |user| user.profile_picture.attached? ? url_for(user.profile_picture) : '' } }
    current_set_players = user_ids.zip(names_abbreviated, names_initials, picture)
    @current_set_players[1] = current_set_players.map { |team| [team.map(&:first).compact, team.map(&:second).compact, team.map(&:third).compact] }
  end

  def set_create_update(params)

    if params[:tournament][:players].present?
      @tournament.players = params[:tournament][:players].reject(&:blank?).map(&:to_i) unless params[:tournament][:players].nil?
    end
    
    if params[:tournament][:teams].present?
      @tournament.players = Team.find(params[:tournament][:teams]).players.collect(&:id)
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
      :name,
      :address1,
      :address2,
      :city,
      :state,
      :zip,
      :date,
      :rounds,
      :team_size,
      :court_side_a_name,
      :court_side_b_name,
      :rounds_configured,
      :rounds_finalized,
      :court_names,
      :tournament_time,
      :break_time,
      :current_set,
      :match_time,
      :pre_match_time,
      :court_1_name,
      :court_2_name,
      :court_3_name,
      :court_4_name,
      :court_5_name,
      :court_6_name,
      :base_team_id,
      players: []
    )
  end
end
