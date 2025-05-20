class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :authenticate_user!
  before_action :check_subscription, unless: :skip_subscription_check?
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
    return true if current_user&.is_admin?
    return true if devise_controller?
    return true if controller_name == 'home'
    super
  end

  def after_sign_in_path_for(resource)
    return leaderboard_path if resource.is_admin?

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

  def skip_subscription_check?
    devise_controller? || 
    controller_name == 'home' || 
    controller_name == 'webhooks' ||
    (controller_name == 'sessions' && action_name == 'new')
  end

  def check_subscription
    return if current_user&.subscribed?
    
    # Store the attempted path for redirect after subscription
    store_location_for(:user, request.fullpath)
    
    redirect_to new_subscription_path, 
                alert: 'Please subscribe to access this feature.'
  end

  def configure_stripe
    # Use test keys in development/test, live keys in production
    if Rails.env.production?
      Stripe.api_key = ENV['STRIPE_KEY']
      @stripe_public_key = ENV['STRIPE_PUBLISHABLE_KEY']
    else
      Stripe.api_key = ENV['STRIPE_TEST_KEY']
      @stripe_public_key = ENV['STRIPE_TEST_PUBLISHABLE_KEY']
    end
  end
end
