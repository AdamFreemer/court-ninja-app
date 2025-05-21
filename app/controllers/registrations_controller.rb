class RegistrationsController < Devise::RegistrationsController
  skip_before_action :check_subscription
  before_action :configure_stripe, only: [:new, :create]

  def new
    @invite_code = params[:invite_code]
    super
  end

  def create
    recaptcha_valid = verify_recaptcha(model: @user)
    
    unless recaptcha_valid
      flash.delete(:recaptcha_error)
      redirect_to new_user_registration_path, 
        alert: 'Captcha error, please try again.' and return
    end

    build_resource(sign_up_params)

    if User.exists?(email: resource.email)
      resource.errors.add(:email, 'is already taken')
      render :new and return
    end

    if resource.password.present? && resource.password.length < 6
      resource.errors.add(:password, 'must be at least 6 characters')
      render :new and return
    end

    super do |resource|
      if resource.persisted?
        resource.is_coach = true
        
        # Explicitly set the API key here
        if Rails.env.production?
          Stripe.api_key = ENV['STRIPE_KEY']
        else
          Stripe.api_key = ENV['STRIPE_KEY'] # Using live key for testing
        end
        
        Rails.logger.info "Stripe API key set: #{Stripe.api_key.present? ? 'Yes' : 'No'}"
        
        # Create Stripe customer
        begin
          customer = Stripe::Customer.create({
            email: resource.email,
            name: "#{resource.first_name} #{resource.last_name}".strip,
            metadata: { user_id: resource.id }
          })
          
          # Only update the stripe_id
          resource.update!(stripe_id: customer.id)
          Rails.logger.info "Created Stripe customer with ID: #{customer.id}"
          
        rescue Stripe::StripeError => e
          Rails.logger.error "Error creating Stripe customer: #{e.message}"
        end
        
        if resource.save
          req = UserRoleRequest.create!(user_id: resource.id)
          req.send_user_request_email
        end
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)
    # Always redirect to the payment link
    { url: 'https://buy.stripe.com/7sYbJ149m1dm0UJ4Dp2sM02', allow_other_host: true }
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end

  def configure_stripe
    if Rails.env.production?
      Stripe.api_key = ENV['STRIPE_KEY']
    else
      Stripe.api_key = ENV['STRIPE_KEY'] # Using live key for now
    end
    Rails.logger.info "Stripe configured with API key present: #{Stripe.api_key.present?}"
  end
end
