class TeamsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_team, only: %i[edit update destroy]

  def index

    @teams = Team.where(coach_id: current_user.id)
  end

  def new
    @team = Team.new
    @action = 'Create'
  end

  def edit
    @action = 'Edit'
  end

  def create
    @team = Team.new(team_params)
    @team.coach_id = current_user.id

    respond_to do |format|
      if @team.save
        format.html { redirect_to teams_path, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # binding.pry
    @team.update_players(params)

    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to teams_path, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      elsif @team.errors
        format.html { redirect_to teams_path, alert: @team.errors.full_messages[0] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team.destroy

    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  private



  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.fetch(:team, [{}]).permit(
      :name,
      :description,
      :coach_id,
      :active,
      :players
    )
  end
end
