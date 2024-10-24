class SessionsController < Devise::SessionsController
  def create
    recaptcha_valid = verify_recaptcha(model: @user)
    if recaptcha_valid
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash.delete(:recaptcha_error)
      redirect_to new_user_session_path, alert: 'Captcha error, please try again.'
    end
  end
end
