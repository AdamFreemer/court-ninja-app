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
    mail(to: @user.email, subject: "Role Request #{user_role_request.status&.capitalize}")
  end

  def existing_athlete_join_team_approval_email(id)
    @pt = PlayerTeam.find(id)
    mail(to: @pt.player.email, subject: "TourneyChamp: You've been added to #{@pt.team.name}")
  end

  def new_athlete_join_team_approval_email(id)
    @pt = PlayerTeam.find(id)
    mail(to: @pt.player.email, subject: "TourneyChamp: You've been added to #{@pt.team.name}")
  end
end
