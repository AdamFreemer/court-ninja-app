module StripeProcessing
  require 'rubygems'
  require 'stripe'

  def self.check_subscription(email)
    return nil if email.blank?

    begin
      # Find customer by email
      customer = Stripe::Customer.list(email: email).first
      return nil unless customer

      # Get subscriptions for customer (both active and trialing)
      subscriptions = Stripe::Subscription.list(
        customer: customer.id,
        status: 'trialing',  # First check trialing
        limit: 1
      )

      # If no trialing subscription, check for active
      if subscriptions.data.empty?
        subscriptions = Stripe::Subscription.list(
          customer: customer.id,
          status: 'active',
          limit: 1
        )
      end

      subscription = subscriptions.data.first

      OpenStruct.new(
        active?: subscription.present?,
        plan: subscription&.plan&.nickname,
        current_period_end: subscription&.current_period_end,
        status: subscription&.status
      )
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      nil
    end
  end

  def self.list_all_customers
    customers = Stripe::Customer.list({limit: 3})
    puts customers
  end
end
