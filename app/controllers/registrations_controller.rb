class RegistrationsController < Devise::RegistrationsController
  def create
    super
    team = Team.find_by(invite_code: params['user']['invite_code']) if params['user']['invite_code'].present?
    resource.add_role :player if params['user']['role'] == 'Player' || team.present?
    resource.teams << team if team
    resource.save!

    return if team

    return unless %w[Coach Organization].include?(params['user']['role'])

    req = UserRoleRequest.create!(user_id: resource.id)
    req.add_role(params['user']['role'].downcase)
    req.send_user_role_request_email
  end
end
