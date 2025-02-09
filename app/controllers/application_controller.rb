class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :authenticate_user!
  before_action :check_if_subscribed
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :user_subscribed?

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  protected

  def configure_permitted_parameters
    attributes = %i[first_name last_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      # redirect_to welcome_path
      # redirect_to login_path, :notice => 'if you want to add a notice'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end
  
  def after_sign_in_path_for(resource)
    subscription = StripeProcessing.check_subscription(resource.email)
    
    # Consider both active and trialing subscriptions as valid
    is_subscribed = subscription&.active? || false
    
    resource.update!(
      subscribed: is_subscribed,
      subscription_status: subscription&.status
    )
    
    if is_subscribed
      leaderboard_path
    else
      redirect_to "https://buy.stripe.com/14k9Ezgq4bDa2kwfYZ", allow_other_host: true and return
    end
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def user_subscribed?
    current_user&.subscribed?
  end

  def require_subscription
    unless user_subscribed?
      redirect_to pricing_path, alert: 'This feature requires an active subscription'
    end
  end

  def check_if_subscribed
    return unless current_user
    return if devise_controller?
    return if controller_name == 'home'
    return if current_user.subscribed?
    return if current_user.is_admin?

    redirect_to "https://buy.stripe.com/14k9Ezgq4bDa2kwfYZ", 
                allow_other_host: true, 
                alert: 'Please subscribe to continue using this feature.'
  end
end
