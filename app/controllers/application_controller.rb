class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authenticate_user!
    if current_user
      super
    else
      redirect_to new_user_session_path
    end
  end

  def configure_permitted_parameters
    attributes = %i[first_name last_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  end
end
