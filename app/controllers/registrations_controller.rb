class RegistrationsController < Devise::RegistrationsController
  skip_before_action :check_subscription

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
        if resource.save
          req = UserRoleRequest.create!(user_id: resource.id)
          req.send_user_request_email
        end
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)
    {
      url: 'https://buy.stripe.com/14k9Ezgq4bDa2kwfYZ',
      allow_other_host: true 
    }
  end
end
