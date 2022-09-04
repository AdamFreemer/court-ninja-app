class RegistrationsController < Devise::RegistrationsController
  def new
    @invite_code = params[:invite_code]
    super
  end

  def create
    super
    team = Team.find_by(invite_code: params['user']['invite_code']) if params['user']['invite_code'].present?
    resource.add_role :athlete if params['user']['role'].downcase == 'athlete' || team.present?
    resource.teams << team if team

    if resource.save
      return if team

      return unless %w[coach organization].include?(params['user']['role'].downcase)

      req = UserRoleRequest.create!(user_id: resource.id)
      req.add_role(params['user']['role'].downcase)
      req.send_user_role_request_email
    else
      redirect_to new_registration_path(@user) && return
    end
  end
end
