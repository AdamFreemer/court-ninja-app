class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_if_subscribed

  # before_action :set_selected_class

  def home
  end

  def learn_more
  end

  def subscription
  end
end
