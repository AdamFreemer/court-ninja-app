class RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.add_role :player if params['user']['role'] == 'Player'
    resource.save!

    return unless %w[Coach Organization].include?(params['user']['role'])

    req = UserRoleRequest.create!(user_id: resource.id)
    req.add_role(params['user']['role'])
  end
end
