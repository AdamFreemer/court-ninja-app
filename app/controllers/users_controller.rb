class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  before_action :set_positions
  before_action :check_for_admin

  def index
    @title = 'All Users'
    @users =
      if params[:sort]
        User.all.where(is_ghost_player: false).order(params[:sort])
      else
        User.all.where(is_ghost_player: false)
      end
  end

  def show
    @user = User.find(current_user.id)
  end

  def profile
    @user = User.find(current_user.id)
  end

  def new
    @submit_button_text = 'Add User'
    @user = User.new
  end

  def edit
    @submit_button_text = 'Edit User'
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save(validate: false)
        format.html { redirect_to user_url(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      # raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      # @user.reset_password_token = enc
      # @user.reset_password_sent_at = Time.now.utc

      if @user.update(user_params)
        # binding.pry
        if params[:user][:update_type] == 'player' || params[:user][:update_type] == 'player_image'
          format.html { redirect_to edit_player_path(@user, is_one_off: @user.is_one_off.to_s), notice: 'Player was successfully updated.' }
        else
          format.html { redirect_to edit_user_path(@user, is_one_off: @user.is_one_off.to_s), notice: 'User was successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @user }
      elsif @user.errors
        format.html { redirect_to users_path, alert: @user.errors.full_messages[0] }
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

  def check_for_admin
    redirect_to players_path unless current_user.is_admin?
  end

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
    params.fetch(:user, [{}]).permit(
      :is_admin,
      :is_coach,
      :is_player,
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
      :profile_picture,
      :password,
      :password_confirmation
    )
  end
end
