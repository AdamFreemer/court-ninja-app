class TeamsController < ApplicationController
  def show; end

  def new
    @team = Team.new
  end

  def edit; end

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

  # def update
  #   respond_to do |format|
  #     if @user.update(user_params)
  #       format.html { redirect_to users_path, notice: 'User was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @user }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  private

  def team_params
    params.fetch(:team, [{}]).permit(:name, :description, :coach_id)
  end
end
