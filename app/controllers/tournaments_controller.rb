class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[
    round_one round_two round_display round_display_single results
    team_scores_update process_round edit update destroy
  ]
  before_action :set_display, only: %i[round_display round_display_single]
  before_action :round_two_generated, only: %i[round_one round_two]

  def index
    @tournaments = Tournament.all.order(:id)
  end

  def new
    @available_players = User.where(is_ghost_player: false).order(:last_name).map { |u| [u.full_name, u.id] }
    @tournament = Tournament.new
    @times = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  end

  def edit
    @available_players = User.where(is_ghost_player: false).order(:last_name).map { |u| [u.full_name, u.id] }
  end

  def round_one #show round one
    @round = 1
    @court_names = [
      @tournament&.court_names&.first,
      @tournament&.court_names&.second
    ]
  end

  def round_two #show round two 
    @round = 2
    @court_names = [
      @tournament&.court_names&.first,
      @tournament&.court_names&.second
    ]
  end

  def round_display # display both courts
    @court_1_matches = @tournament.matches.where(court: 1, round: params[:round])
    @court_2_matches = @tournament.matches.where(court: 2, round: params[:round])
  end

  def round_display_single
    @timer_minutes = 2
    @court = params[:court].to_i
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
    round = params[:round].to_i
    if @tournament.rounds_finalized.include?(round)
      redirect_to round_one_tournament_url(@tournament), notice: 'Round already processed.'
    end
    @tournament.create_user_scores(round)
    rounds_finalized = @tournament.rounds_finalized
    rounds_finalized << round
    @tournament.update(rounds_finalized: rounds_finalized, current_set: round == 1)
    @tournament.round_two_courts_generate(@tournament.player_ranking(1)) if round == 1

  
    case round
    when 1
      redirect_to round_two_tournament_url(@tournament), notice: 'Round 1 successfully processed.'
    when 2
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
        redirect_to round_one_tournament_url(@tournament), notice: "Tournament was successfully created."
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
    @times = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  end

  def set_display
    @current_set = @tournament.current_set
    @round = params[:round]
  end

  def set_create_update(params)
    @tournament.players = params[:tournament][:players].reject(&:blank?).map(&:to_i) unless params[:tournament][:players].nil?
    @tournament.time = params[:tournament][:time].to_i * 60
    @tournament.court_names = params[:tournament][:court_names].gsub(/\s+/m, ' ').strip.split(" ")
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
    params.fetch(:tournament, [{}]).permit(:name, :address1, :address2, :city, :state, :zip, :date, :players, :courts,
      :rounds, :team_size, :rounds_configured, :rounds_finalized, :court_names, :time, :current_set
    )
  end
end


# t.string "name"
# t.string "address1"
# t.string "address2"
# t.string "city"
# t.string "state"
# t.string "zip"
# t.datetime "date"
# t.integer "courts"
# t.integer "team_size"
# t.string "rounds_configured", default: [], array: true
# t.string "rounds_finalized", default: [], array: true
# t.string "players", default: [], array: true
# t.string "court_names", default: [], array: true
# t.integer "time"
# t.integer "current_set", default: 1
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false