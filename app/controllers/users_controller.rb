class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users =
      if params[:sort]
        User.where(is_ghost_player: false).order(params[:sort])
      else
        User.where(is_ghost_player: false)
      end
  end

  def show
    @user = User.find(current_user.id)
    @positions =
      [
        ['Setter (S)', 1],
        ['Outside Hitter (OH)', 2],
        ['Opposite/Right Side Hitter (OPPO/RS)', 3],
        ['Middle (M)', 3],
        ['Libero (LIB)', 4],
        ['Defensive Specialist (DS)', 5]
      ]
    @teams = @user.teams
  end

  def new
    @user = User.new
  end

  def edit
    @teams = @user.teams
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
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      elsif @user.errors
        @teams = @user.teams
        format.html { redirect_to root_path, alert: @user.errors.full_messages[0] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.fetch(:user, [{}]).permit(
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
      :profile_picture
    )
  end
end
