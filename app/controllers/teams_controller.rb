class TeamsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:verify]

  def show; end

  def new
    @team = Team.new
  end

  def edit
    @team = Team.find(params[:id])
  end

  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save(validate: false)
        format.html { redirect_to root_url, notice: 'Team was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to root_url, notice: 'Team was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def verify
    @team = Team.find_by(invite_code: params[:invite_code])

    render json: {
      team_name: @team&.name,
      status: @team.present? ? 'success' : 'failure'
    }
  end

  def join
    @team = Team.find_by(invite_code: params[:invite_code])
    current_user.teams << @team
    current_user.save!
  end

  def remove_player
    team = Team.find(params[:team_id])
    player = User.find(params[:player_id])
    team.players.delete(player)

    redirect_to root_path
  end

  private

  def team_params
    params.fetch(:team, [{}]).permit(:name, :description, :coach_id, :active)
  end
end
