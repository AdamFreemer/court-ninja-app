class UserMailer < ApplicationMailer
  default from: 'from@example.com'
  layout 'mailer'

  def user_role_request_email(user_role_request)
    @user_role_request = user_role_request
    @user = user_role_request.user
    mail(to: User.with_role(:admin).pluck(:email), from: @user.email, subject: 'New User Request')
  end

  def role_request_processed_email(user_role_request)
    @user_role_request = user_role_request
    @user = user_role_request.user
    mail(to: @user.email, subject: "Role Request #{user_role_request.status.capitalize}")
  end
end
