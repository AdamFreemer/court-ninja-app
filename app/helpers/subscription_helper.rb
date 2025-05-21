module SubscriptionHelper
  def subscription_link_attributes
    if current_user
      if current_user.subscribed?
        {
          href: '#',
          disabled: true,
          class: 'opacity-50 cursor-not-allowed'
        }
      else
        {
          href: 'https://buy.stripe.com/7sYbJ149m1dm0UJ4Dp2sM02',
          target: '_blank',
          data: { turbo: false },
          allow_other_host: true
        }
      end
    else
      {
        href: new_user_registration_path
      }
    end
  end
end 