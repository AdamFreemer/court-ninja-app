class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[round_one round_two round_display round_display_single results team_scores_update process_round edit update destroy]
  before_action :round_two_generated, only: %i[round_one round_two]
  before_action :set_display, only: %i[round_display round_display_single]

  def index
    @tournaments = Tournament.all.order(:id)
  end

  def new
    @available_players = User.where(is_ghost_player: false).order(:last_name).map { |u| [u.full_name, u.id] }
    @tournament = Tournament.new
  end

  def edit
    @available_players = User.where(is_ghost_player: false).order(:last_name).map { |u| [u.full_name, u.id] }
  end

  def round_one #show round one
  end

  def round_two #show round two 
  end

  def round_display # display both courts
    @court_1_matches = @tournament.matches.where(court: 1, round: params[:round])
    @court_2_matches = @tournament.matches.where(court: 2, round: params[:round])
  end

  def round_display_single
    @court = params[:court]
    @court_matches = @tournament.matches.where(court: @court, round: params[:round])
  end

  def results # show results
    players_gold = @tournament.player_ranking(2)[0]
    @players_gold_winner = @tournament.player_ranking(2)[0].first
    players_gold.shift
    @players_gold = players_gold
    @players_silver = @tournament.player_ranking(2)[1]
  end

  def team_scores_update
    score_date = request.params['score_data']
    Team.score_update(score_date)
    @tournament.update_current_set(score_date)

    render json: {}
  end

  def process_round
    # params: :id / :round
    if params[:round].to_i == 1
      return if @tournament.round_1_finalized #this prevents from doubling up create user_scores

      @tournament.create_user_scores(params[:round].to_i)
      @tournament.update(round_1_finalized: true, current_set: 1)
      @tournament.round_two_courts_generate(@tournament.player_ranking(1))

      redirect_to round_two_tournament_url(@tournament), notice: "Round 1 successfully processed."
    elsif params[:round].to_i == 2
      return if @tournament.round_2_finalized

      @tournament.create_user_scores(params[:round].to_i)
      @tournament.update(round_2_finalized: true)

      redirect_to results_tournament_url(@tournament), notice: "Round 2 successfully processed."
    end
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.players = params[:tournament][:players].reject(&:blank?).map(&:to_i)

    if @tournament.save
      tournament = TournamentGenerator.new(@tournament, @tournament.players)
      tournament.generate_round(1)

      redirect_to round_one_tournament_url(@tournament), notice: "Tournament was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @tournament.update(tournament_params)
      redirect_to round_one_tournament_url(@tournament), notice: "Tournament was successfully updated."
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
  end

  def set_display
    @current_set = @tournament.current_set
    @round = params[:round]
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
    params.fetch(:tournament, [{}]).permit(:name, :address1, :address2, :city, :state, :zip, :date, :players, :courts)
  end
end
