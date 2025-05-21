class SubscriptionsController < ApplicationController
  skip_before_action :check_subscription
  before_action :configure_stripe
  
  def new
    # Redirect to leaderboard if already subscribed
    if current_user.subscribed? && current_user.subscription_status == "active"
      redirect_to leaderboard_path, notice: "You already have an active subscription." and return
    end
    
    # Show subscription page for non-subscribed users
  end

  def create
    # Don't process if already subscribed
    if current_user.subscribed? && current_user.subscription_status == "active"
      redirect_to leaderboard_path, notice: "You already have an active subscription." and return
    end
    
    # Explicitly set API key again for safety
    Stripe.api_key = ENV['STRIPE_KEY']

    begin
      # Create a checkout session for this specific customer
      session = Stripe::Checkout::Session.create({
        customer: current_user.stripe_id,
        payment_method_types: ['card'],
        line_items: [{
          price: 'price_1QUgUzHU14mwu7Kl5FcGg5gp', # Replace with your actual price ID from Stripe
          quantity: 1,
        }],
        mode: 'subscription',
        subscription_data: {
          trial_period_days: 30
        },
        success_url: "#{request.base_url}/subscriptions/success?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "#{request.base_url}/subscriptions/cancel"
      })

      redirect_to session.url, allow_other_host: true
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: #{e.message}"
      redirect_to new_subscription_path, alert: "Payment processing error: #{e.message}"
    end
  end

  def success
    session_id = params[:session_id]

    if session_id
      # Just record the session ID - actual status update will come via webhook
      flash[:notice] = "Thanks for subscribing! Your account will be updated shortly."
      redirect_to leaderboard_path
    else
      # If coming from payment link (without session_id), manually check subscription
      check_subscription_status
      redirect_to leaderboard_path, notice: "Thanks for subscribing! Your account has been updated."
    end
  end

  def cancel
    redirect_to new_subscription_path, alert: "Subscription was cancelled."
  end

  # New method to check subscription status after payment link completion
  def check_subscription_status
    return unless current_user && current_user.stripe_id.present?
    
    Stripe.api_key = ENV['STRIPE_KEY']
    
    begin
      # Get subscriptions for customer
      subscriptions = Stripe::Subscription.list(
        customer: current_user.stripe_id,
        limit: 1
      )
      
      if subscription = subscriptions.data.first
        Rails.logger.info "Found subscription for user #{current_user.email}: status=#{subscription.status}"
        
        # Update user subscription status
        current_user.update!(
          subscribed: ['active', 'trialing'].include?(subscription.status),
          subscription_status: subscription.status
        )
        
        Rails.logger.info "Updated user subscription: subscribed=#{current_user.subscribed}, status=#{current_user.subscription_status}"
      else
        Rails.logger.info "No subscription found for user #{current_user.email}"
      end
    rescue Stripe::StripeError => e
      Rails.logger.error "Error checking subscription: #{e.message}"
    end
  end

  private

  def configure_stripe
    # Make sure to explicitly set the API key
    Stripe.api_key = ENV['STRIPE_KEY']
    Rails.logger.info "Subscriptions: Stripe API key set: #{Stripe.api_key.present? ? 'Yes' : 'No'}"
  end
end 