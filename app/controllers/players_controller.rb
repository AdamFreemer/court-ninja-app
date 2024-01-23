class PlayersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_user, only: %i[edit update destroy]
  before_action :set_positions

  def leaderboard
    players =
      if params[:sort]
        current_user.players.where(is_ghost_player: false, is_one_off: false, is_on_leaderboard: true).order(params[:sort])
      else
        current_user.players.where(is_ghost_player: false, is_one_off: false, is_on_leaderboard: true)
      end

      @players = []
      players.each do |player|

        @players << [player.profile_picture, player.full_name, player.player_statistics]
      end
      # binding.pry
  end

  def index
    @title = 'Player Management'
    players =
      if params[:sort]
        current_user.players.where(is_ghost_player: false).order(params[:sort])
      else
        current_user.players.where(is_ghost_player: false)
      end
    @players_one_off = players.all.where(is_one_off: true, is_active: true).where('created_at > ?', 2.days.ago)
    @players_team = players.all.where(is_one_off: false, is_active: true)
  end

  def new
    @type = if params[:type] == 'team'
              'Team'
            else
              'One Off'
            end
    @submit_button_text = 'Create Player'
    @user = User.new
  end

  def edit
    @submit_button_text = 'Update'
  end

  def create
    @user = User.new(user_params)
    @user.coach = current_user

    respond_to do |format|
      if @user.save(validate: false)
        format.html { redirect_to players_path, notice: 'Player was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to players_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      elsif @user.errors
        @teams = @user.teams
        format.html { redirect_to players_path, alert: @user.errors.full_messages[0] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_positions
    @positions =
      [
        ['Setter (S)', 1],
        ['Outside Hitter (OH)', 2],
        ['Opposite/Right Side Hitter (OPPO/RS)', 3],
        ['Middle (M)', 3],
        ['Libero (LIB)', 4],
        ['Defensive Specialist (DS)', 5]
      ]
  end

  def user_params
    params.permit(
      :email,
      :first_name,
      :last_name,
      :nick_name,
      :address,
      :city,
      :state,
      :zip,
      :phone_number,
      :jersey_number,
      :position,
      :gender,
      :contact_1_name,
      :contact_1_phone,
      :contact_1_address,
      :contact_2_name,
      :contact_2_phone,
      :contact_2_address,
      :date_of_birth,
      :profile_picture
    )
  end
end
