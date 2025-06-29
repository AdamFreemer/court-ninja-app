class SessionsController < Devise::SessionsController
  skip_before_action :check_subscription
  skip_before_action :authenticate_user!, except: [:destroy]
  
  def new
    if user_signed_in?
      # For users who hit back after stripe redirect
      if request.referer&.include?('stripe.com')
        redirect_to dashboard_path, 
          alert: 'Please complete your subscription to access all features.' and return
      end

      # Regular signed-in user handling
      if !current_user.is_admin? && !current_user.subscribed?
        redirect_to dashboard_path, 
          alert: 'Please subscribe to continue.' and return
      end

      redirect_to leaderboard_path
    else
      @from_stripe = request.referer&.include?('stripe.com')
      super
    end
  end

  def create
    self.resource = warden.authenticate!(auth_options)

    if resource
      sign_in(resource_name, resource)

      # Add admin check here
      if resource.is_admin?
        redirect_to leaderboard_path and return
      end

      subscription = StripeProcessing.check_subscription(resource.email)
      is_subscribed = subscription&.active? || false

      resource.update!(
        subscribed: is_subscribed,
        subscription_status: subscription&.status
      )

      if is_subscribed
        redirect_to leaderboard_path and return
      else
        if params[:from_stripe]
          redirect_to dashboard_path, alert: 'Please complete your subscription to access all features.' and return
        else
          redirect_to 'https://buy.stripe.com/7sYbJ149m1dm0UJ4Dp2sM02', allow_other_host: true and return
        end
      end
    else
      redirect_to new_user_session_path, 
        alert: 'Invalid email or password.' and return
    end
  end

  private

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
      new_subscription_path
    end
  end
end
