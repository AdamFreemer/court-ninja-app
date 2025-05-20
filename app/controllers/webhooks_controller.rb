class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  skip_before_action :check_subscription

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET']
      )
      Rails.logger.info "Stripe webhook received: #{event.type}"
      Rails.logger.info "Event data: #{event.data.object.to_json}"
    rescue JSON::ParserError => e
      Rails.logger.error "Webhook JSON parse error: #{e.message}"
      return head :bad_request
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error "Webhook signature verification failed: #{e.message}"
      return head :bad_request
    end

    handle_stripe_event(event)
    head :ok
  end

  private

  def handle_stripe_event(event)
    Rails.logger.info "Processing Stripe event: #{event.type}"
    
    case event.type
    when 'checkout.session.completed'
      handle_checkout_completed(event.data.object)
    when 'customer.subscription.created'
      handle_subscription_created(event.data.object)
    when 'customer.subscription.updated'
      handle_subscription_updated(event.data.object)
    when 'customer.subscription.deleted'
      handle_subscription_deleted(event.data.object)
    when 'invoice.payment_succeeded'
      handle_payment_succeeded(event.data.object)
    when 'invoice.payment_failed'
      handle_payment_failed(event.data.object)
    else
      Rails.logger.info "Unhandled event type: #{event.type}"
    end
  end

  def handle_checkout_completed(session)
    # Find user by customer ID
    user = User.find_by(stripe_id: session.customer)
    return unless user

    Rails.logger.info "Checkout completed for user #{user.email}"
    
    # The subscription status will be updated by the subscription.created webhook
    # We don't need to update anything here
  end

  def handle_subscription_created(subscription)
    user = find_user_by_customer(subscription.customer)
    return unless user

    Rails.logger.info "Subscription created for user #{user.email}"
    
    user.update!(
      subscribed: true,
      subscription_status: subscription.status
    )
  end

  def handle_subscription_updated(subscription)
    user = find_user_by_customer(subscription.customer)
    return unless user

    Rails.logger.info "Subscription updated for user #{user.email}: status=#{subscription.status}"
    
    user.update!(
      subscribed: subscription.status == 'active',
      subscription_status: subscription.status
    )
  end

  def handle_subscription_deleted(subscription)
    user = find_user_by_customer(subscription.customer)
    return unless user

    Rails.logger.info "Subscription deleted for user #{user.email}"
    
    user.update!(
      subscribed: false,
      subscription_status: 'canceled'
    )
  end

  def handle_payment_succeeded(invoice)
    user = find_user_by_customer(invoice.customer)
    return unless user

    Rails.logger.info "Payment succeeded for user #{user.email}"
    
    # The subscription status will be updated by the subscription.updated webhook
    # We don't need to update anything here
  end

  def handle_payment_failed(invoice)
    user = find_user_by_customer(invoice.customer)
    return unless user

    Rails.logger.info "Payment failed for user #{user.email}"
    
    user.update!(subscription_status: 'past_due')
    # Don't set subscribed to false yet - they might still resolve payment
  end

  private

  def find_user_by_customer(customer_id)
    user = User.find_by(stripe_id: customer_id)
    if user
      Rails.logger.info "Found user #{user.email} for Stripe customer: #{customer_id}"
    else
      Rails.logger.error "No user found for Stripe customer: #{customer_id}"
    end
    user
  end
end 