class TournamentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tournament, only: %i[ status timer_operation
    administration display_single display_double results
    team_scores_update process_round edit update destroy
  ]
  before_action :set_display, only: %i[display_single display_double]
  before_action :round_two_generated, only: %i[administration]

  def index
    @tournaments = Tournament.all.order(:id)
  end

  def new
    @available_players = User.where(is_ghost_player: false).order(:last_name) #.map { |u| [u.full_name, u.id] }
    @tournament = Tournament.new
    @tournament_times = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @break_times = [0.5, 1, 1.5]
    @tournament_configured = !@tournament.rounds_configured.empty?
  end

  def edit
    @available_players = User.where(is_ghost_player: false).order(:last_name) #.map { |u| [u.full_name, u.id] }
    @tournament_configured = !@tournament.rounds_configured.empty?
  end

  def administration
  end

  def results
    rounds = @tournament.rounds
    # show results
    players_gold = @tournament.player_ranking(rounds)[0]
    @players_gold_winner = @tournament.player_ranking(rounds)[0].first
    players_gold.shift
    @players_gold = players_gold
    @players_silver = @tournament.player_ranking(rounds)[1]
  end

  def display_double
    # show display both courts
    @court_1_matches = @tournament.matches.where(court: 1, round: params[:round])
    @court_2_matches = @tournament.matches.where(court: 2, round: params[:round])
  end

  def display_single
    # show display single
    @timer_minutes = 2
    @court = params[:court].to_i
    @court_matches = @tournament.matches.where(court: @court, round: params[:round])
  end

  def team_scores_update
    score_date = request.params['score_data']
    Team.score_update(score_date)
    @tournament.update_current_set(score_date)
    @tournament.update!(timer_status: "reset")
    render json: {}
  end

  def status
    render json: {
      timer_status: @tournament.timer_status,
      current_set: @tournament.current_set
    }
  end

  def timer_operation
    operation = params[:operation]

    if operation == "start"
      @tournament.timer_status = "start"
    elsif operation == "reset"
      @tournament.timer_status = "reset"
    end
    @tournament.save

    render json: { timer_status: @tournament.timer_status}
  end

  def process_round
    # params: :id / :round
    round = params[:round].to_i
    if @tournament.rounds_finalized.include?(round)
      redirect_to round_one_tournament_url(@tournament), notice: 'Round already processed.'
    end
    @tournament.create_user_scores(round)
    rounds_finalized = @tournament.rounds_finalized
    rounds_finalized << round
    @tournament.update(rounds_finalized: rounds_finalized, current_set: round == 1)
    @tournament.round_two_courts_generate(@tournament.player_ranking(1)) if round == 1 && @tournament.rounds > 1

    if round == 1 && @tournament.rounds > 1
      redirect_to administration_tournament_url(@tournament, 2), notice: 'Round 1 successfully processed.'
    elsif round == 1 && @tournament.rounds == 1
      redirect_to results_tournament_url(@tournament), notice: 'Round successfully processed.'
    elsif round == 2
      redirect_to results_tournament_url(@tournament), notice: 'Round 2 successfully processed.'
    else
      redirect_to tournaments_path
    end
  end

  def create
    @tournament = Tournament.new(tournament_params)
    set_create_update(params)

    if @tournament.save
      if @tournament.generate_tournament
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
        if @tournament.generate_tournament
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

  # Use callbacks to share common setup or constraints between actions.
  def set_tournament
    @tournament = Tournament.find(params[:id])
    @tournament_times = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @break_times = [0.5, 1, 1.5]
  end

  def set_display
    @current_set = @tournament.current_set
    @round = params[:round]
  end

  def set_create_update(params)
    @tournament.players = params[:tournament][:players].reject(&:blank?).map(&:to_i) unless params[:tournament][:players].nil?
  end

  def round_two_generated
    @round_two_generated = if Tournament.find(params[:id]).matches.where(round: 2).count.positive?
                             true
                           else
                             false
                           end
  end

  # Only allow a list of trusted parameters through.
  def tournament_params
    params.fetch(:tournament).permit(
      :name, :address1, :address2, :city, :state, :zip, :date, :rounds, :team_size,
      :rounds_configured, :rounds_finalized, :court_names, :tournament_time, :break_time, :current_set,
      :court_1_name, :court_2_name, :court_3_name, :court_4_name, :court_5_name, :court_6_name, players: []
    )
  end
end
