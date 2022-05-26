class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def send_user_role_request_email(user_role_request)
    @user_role_request = user_role_request
    @user = user_role_request.user
    mail(to: User.where(admin: true).pluck(:email), subject: 'New User Role Request')
  end

  def send_role_request_processed_email(user_role_request)
    @user_role_request = user_role_request
    @user = user_role_request.user
    mail(to: @user.email, subject: "Role Request #{user_role_request.status.capitalize}")
  end
end
