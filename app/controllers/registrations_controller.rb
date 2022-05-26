class RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.player = true if params['user']['role'] == 'Player'
    resource.save!
    UserRoleRequest.create!(user_id: resource.id, role: params['user']['role']) if ['Coach', 'Tournament Organizer'].include?(params['user']['role'])
  end
end
