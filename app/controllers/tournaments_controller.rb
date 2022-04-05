class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[ show edit update destroy ]

  # GET /tournaments or /tournaments.json
  def index
    @tournaments = Tournament.all.order(:id)
  end

  # GET /tournaments/1 or /tournaments/1.json
  def show
    #TODO - create views based on tournament counts, based off generation
    @score_tags = []
    @tournament.teams.each do |team|
      @score_tags << team.id
    end
  end

  # GET /tournaments/new
  def new
    @t_users = User.where(is_ghost_player?: false).order(:last_name).map { |u| [u.full_name, u.id] }
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
  end

  # POST /tournaments or /tournaments.json
  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.players = params[:tournament][:players].reject(&:blank?)

    respond_to do |format|
      if @tournament.save
        tournament = TournamentGenerator.new(@tournament, @tournament.players)
        tournament.generate_tournament

        format.html { redirect_to tournament_url(@tournament), notice: "Tournament was successfully created." }
        format.json { render :show, status: :created, location: @tournament }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1 or /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to tournament_url(@tournament), notice: "Tournament was successfully updated." }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1 or /tournaments/1.json
  def destroy
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: "Tournament was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def team_scores_update
    teams_count = request.params['score_data'].length
    teams_count_array = [*0..teams_count - 1].map(&:to_s)
    teams_count_array.each do |team_number|
      team = request.params['score_data'][team_number]
      team_lookup = Team.find_by(id: team['team_id'])
      next if team_lookup.work_team? == true

      team_lookup.update(score: team['score'])
    end

    render json: {}
  end

  private

  def configure_tournament(tournament, players)

  end

  # Use callbacks to share common setup or constraints between actions.
  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tournament_params
    params.fetch(:tournament, [{}]).permit(:name, :address1, :address2, :city, :state, :zip, :date, :players, :courts)
  end
end
