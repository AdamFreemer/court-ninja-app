class SessionsController < Devise::SessionsController
  skip_before_action :check_if_subscribed
  skip_before_action :authenticate_user!, except: [:destroy]
  
  def new
    @from_stripe = request.referer&.include?('stripe.com')
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    
    if resource
      sign_in(resource_name, resource)
      subscription = StripeProcessing.check_subscription(resource.email)
      is_subscribed = subscription&.active? || false
      
      resource.update!(
        subscribed: is_subscribed,
        subscription_status: subscription&.status
      )
      
      if is_subscribed
        redirect_to leaderboard_path
      else
        if params[:from_stripe]
          redirect_to leaderboard_path, alert: 'Please complete your subscription to access all features.'
        else
          redirect_to "https://buy.stripe.com/14k9Ezgq4bDa2kwfYZ", allow_other_host: true
        end
      end
    else
      redirect_to new_user_session_path, alert: 'Invalid email or password.'
    end
  end

  private

  def after_sign_in_path_for(resource)
    super
  end
end
