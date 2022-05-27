class UserRoleRequestsController < ApplicationController
  before_action :check_authorization
  before_action :set_user_role_request

  def approve
    @user_role_request.update!(status: 'approved', processed_at: Time.current, processed_by_id: current_user.id)
    user = @user_role_request.user
    user.coach = true if @user_role_request.role == 'Coach'
    user.tournament_organizer = true if @user_role_request.role == 'Tournament Organizer'
    user.save!
    ApplicationMailer.send_role_request_processed_email(@user_role_request).deliver_now
    redirect_to @user_role_request.user
  end

  def deny
    @user_role_request.update!(status: 'denied', processed_at: Time.current, processed_by_id: current_user.id)
    ApplicationMailer.send_role_request_processed_email(@user_role_request).deliver_now
    user = @user_role_request.user
    user.coach = false if @user_role_request.role == 'Coach'
    user.tournament_organizer = false if @user_role_request.role == 'Tournament Organizer'
    user.save!
    redirect_to @user_role_request.user
  end

  private

  def set_user_role_request
    @user_role_request = UserRoleRequest.find(params[:id])
  end

  def check_authorization
    raise User::NotAuthorized unless current_user.admin?
  end
end
