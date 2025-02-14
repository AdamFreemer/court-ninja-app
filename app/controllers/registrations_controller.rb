class RegistrationsController < Devise::RegistrationsController
  skip_before_action :check_subscription  # Updated from check_if_subscribed
  def new
    @invite_code = params[:invite_code]
    super
  end

  # def after_sign_up_path_for(resource)
  #   'https://buy.stripe.com/14k9Ezgq4bDa2kwfYZ', allow_other_host: true
  # end
  def create
    # team = Team.find_by(invite_code: params['user']['invite_code']) if params['user']['invite_code'].present?
    # resource.add_role :athlete if params['user']['role'].downcase == 'athlete' || team.present?
    # resource.teams << team if team
    recaptcha_valid = verify_recaptcha(model: @user)
    if recaptcha_valid
      super 
      # set new user as coach
      resource.is_coach = true
      if resource.save
        # return if team
        # return unless %w[coach organization].include?(params['user']['role'].downcase)
        req = UserRoleRequest.create!(user_id: resource.id)
        # req.add_role(params['user']['role'].downcase)
        req.send_user_request_email
      else
        redirect_to new_registration_path(@user), alert: 'Sign up error, please try again.' && return
      end
    else
      flash.delete(:recaptcha_error)
      redirect_to new_user_registration_path, alert: 'Captcha error, please try again.'
    end
  end
end
