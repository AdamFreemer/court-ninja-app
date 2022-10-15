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

    redirect_back(fallback_location: root_path)
  end

  def add_player_to_team
    team = Team.find(Integer(athlete_params[:team_id], 10))
    user = User.find_by(email: athlete_params[:email])

    if user
      player_team = PlayerTeam.find_by(team: team, player: user)

      if player_team
        flash[:notice] = 'Athlete is already on this team'
      else
        pt = PlayerTeam.create!(team: team, player: user, pending: true)
        UserMailer.existing_athlete_join_team_approval_email(pt.id).deliver_now
      end
    else
      pw = SecureRandom.uuid
      user = User.create!(email: athlete_params[:email], first_name: athlete_params[:first_name], last_name: athlete_params[:last_name], password: pw, password_confirmation: pw)
      pt = PlayerTeam.create!(team: team, player: user, pending: true)
      UserMailer.new_athlete_join_team_approval_email(pt.id).deliver_now
    end

    redirect_back(fallback_location: root_path)
  end

  def existing_athlete_join_team_approval
    pt = PlayerTeam.find_by(uuid: params[:uuid])

    if pt.player == current_user
      pt.pending = false
      pt.save!
      flash[:notice] = 'Successfully joined the team!'
    else
      flash[:error] = 'Error: Mismatch between logged in user and athlete associated with request'
    end

    redirect_to root_path
  end

  private

  def athlete_params
    params.fetch(:user).permit(:first_name, :last_name, :email, :team_id)
  end

  def team_params
    params.fetch(:team, [{}]).permit(:name, :description, :coach_id, :active)
  end
end
