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
          redirect_to dashboard_path, 
            alert: 'Please complete your subscription to access all features.' and return
        else
          redirect_to "https://buy.stripe.com/14k9Ezgq4bDa2kwfYZ", 
            allow_other_host: true and return
        end
      end
    else
      redirect_to new_user_session_path, 
        alert: 'Invalid email or password.' and return
    end
  end
end
