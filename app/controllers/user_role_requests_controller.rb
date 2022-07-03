class UserRoleRequestsController < ApplicationController
  before_action :set_user_role_request

  def approve
    return unless current_user.is_admin?

    @user_role_request.update!(status: 'approved', processed_at: Time.current, processed_by_id: current_user.id)
    user = @user_role_request.user
    @user_role_request.roles.each do |role|
      user.add_role(role.name)
    end
    UserMailer.role_request_processed_email(@user_role_request).deliver_now
    flash[:notice] = "User #{user.email} has been granted the role(s) #{@user_role_request.roles.map(&:name).join(', ')}"
    redirect_to root_path
  end

  def deny
    return unless current_user.is_admin?

    @user_role_request.update!(status: 'denied', processed_at: Time.current, processed_by_id: current_user.id)
    UserMailer.role_request_processed_email(@user_role_request).deliver_now
    user = @user_role_request.user
    @user_role_request.roles.each do |role|
      user.remove_role(role.name)
    end
    flash[:notice] = "User #{user.email} has been denied the role(s) #{@user_role_request.roles.map(&:name).join(', ')}"
    redirect_to root_path
  end

  private

  def set_user_role_request
    @user_role_request = UserRoleRequest.find(params[:id])
  end
end
