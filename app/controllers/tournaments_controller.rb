class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[status tournament_status
    administration display_single display_multiple results
    team_scores_update process_round edit update destroy timer_operation
  ]
  before_action :set_display, only: %i[display_single display_multiple]
  before_action :round_two_generated, only: %i[administration]

  def index
    if params[:filter] == "before-today"
      @tournaments = Tournament.before_today.order(created_at: :desc)
    elsif params[:filter] == "today"
      @tournaments = Tournament.today.order(created_at: :desc)
    elsif params[:filter] == "all"
      @tournaments = Tournament.all.order(created_at: :desc)
    else
      @tournaments = Tournament.today.order(created_at: :desc)
    end

    @tournaments = @tournaments.where(created_by_id: current_user.id) if current_user.is_coach?

    respond_to do |format|
      format.js { render layout: false }
      format.html { render 'index' }
    end
  end

  def new
    current_user&.is_coach? ? @max_players = 14 : @max_players = 14 
    @available_players =
      if current_user&.is_coach?
        players = current_user.teams_coached.map(&:players)
        players.flatten!.sort_by(&:last_name)
      else
        User.where(is_ghost_player: false).order(:last_name)
      end
    @type = params[:type]
    @tournament = Tournament.new
    @tournament_times = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @break_times = [0.1, 0.5, 1, 1.5]
    @tournament_configured = !@tournament.rounds_configured.empty?
  end

  def edit
    current_user&.is_coach? ? @max_players = 14 : @max_players = 14 
    @available_players =
      if current_user&.is_coach?
        players = current_user.teams_coached.map(&:players)
        players.flatten!.sort_by(&:last_name)
      else
        User.where(is_ghost_player: false).order(:last_name)
      end
    @tournament_configured = !@tournament.rounds_configured.empty?
    @player_names = @tournament.users.collect { |player| player.name_abbreviated }
  end

  def administration; end

  def results
    rounds = @tournament.rounds
    # show results
    players_gold = @tournament.player_ranking(rounds)[0]
    @players_gold_winner = @tournament.player_ranking(rounds)[0].first
    players_gold.shift
    @players_gold = players_gold
    @players_silver = @tournament.player_ranking(rounds)[1]
  end

  def display_single
    # display any court based on court param passed along
    @court = params[:court].to_i
    @court_sets = @tournament.tournament_sets.where(court: @court, round: params[:round])
  end

  def display_multiple
    @court_1_sets = @tournament.tournament_sets.where(court: 1, round: params[:round])
    @court_2_sets = @tournament.tournament_sets.where(court: 2, round: params[:round])
  end

  def team_scores_update
    score_date = request.params['score_data']
    TournamentTeam.score_update(score_date)
    @tournament.update_current_set(score_date)
    # @tournament.update!(timer_state: "reset")
    render json: {}
  end

  def status
    scores = @tournament.tournament_teams.collect { |t| [t.id, t.score] }
    render json: {
      scores: scores,
      current_set: @tournament.current_set,
      current_round: @tournament.current_round,
      timer_state: @tournament.timer_state,
      timer_mode: @tournament.timer_mode,
      timer_time: @tournament.timer_time,
      tournament_completed: @tournament.tournament_completed
    }
  end

  def timer_operation
    puts "== Timer Updated"
    puts "== Timer Time: #{params[:time]}"
    @tournament.update!(timer_state: params[:state], timer_mode: params[:mode], timer_time: params[:time])

    render json: {
      timer_state: @tournament.timer_state,
      timer_mode: @tournament.timer_mode,
      timer_time: @tournament.timer_time
    }
  end

  def process_round
    round = params[:round].to_i # params: :id / :round
    if @tournament.rounds_finalized.include?(round)
      redirect_to administration_tournament_url(@tournament, round), notice: 'Round already processed.'
    end
    # Check rounds_finalized array if it contains current round which means round already finalized, if not, process round
    @tournament.create_user_scores(round)
    # Grab current rounds finalized, push in current round just finalized (if first round, rounds_finalized will be empty to start)
    rounds_finalized = @tournament.rounds_finalized
    rounds_finalized << round
    @tournament.generate unless @tournament.rounds_finalized.count >= @tournament.rounds
    @tournament.update(
      tournament_completed: tournament_status,
      rounds_finalized: rounds_finalized,
      current_set: 1,
      current_round: rounds_finalized == @tournament.rounds ? round : round + 1
    )

    # This logic determines when final round is completed and go to results page
    if round == 1 && @tournament.rounds == 1 # Keeping round number agnostic if 1 round tournament
      redirect_to results_tournament_url(@tournament), notice: 'Round successfully processed.'
    elsif @tournament.rounds > round # when current round is less than total rounds
      redirect_to administration_tournament_url(@tournament, round + 1), notice: "Round #{round} successfully processed."
    elsif @tournament.tournament_completed # when all rounds finalized == total rounds as per tournament generation
      redirect_to results_tournament_url(@tournament), notice: 'Tournament results processed.'
    else
      redirect_to tournaments_path
    end
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.created_by = current_user

    set_create_update(params)
    if @tournament.save
      if @tournament.generate
        @tournament.update(current_round: 1)
        redirect_to administration_tournament_url(@tournament, 1), notice: "Tournament was successfully created."
      else
        redirect_to tournaments_path
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @tournament.update(tournament_params)
      set_create_update(params)
      @tournament.save
      if @tournament.rounds_configured.empty?
        if @tournament.generate
          redirect_to tournaments_path, notice: "Tournament updated and round one successfully created."
        else
          redirect_to tournaments_path, notice: "Tournament was successfully updated (no rounds created)."
        end
      else
        redirect_to tournaments_path, notice: "Tournament information updated."
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

  private

  def tournament_status
    return true if @tournament.rounds_finalized.count == @tournament.rounds

    false
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_tournament
    @tournament = Tournament.find(params[:id])
    @tournament_times = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @break_times = [0.1, 0.5, 1, 1.5]
  end

  def set_display
    @current_set = @tournament.current_set
    @round = params[:round]
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
      :rounds_configured, :rounds_finalized, :court_names, :tournament_time, :break_time, :current_set,
      :court_1_name, :court_2_name, :court_3_name, :court_4_name, :court_5_name, :court_6_name, players: []
    )
  end
end
