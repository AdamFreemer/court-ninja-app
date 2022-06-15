class DashboardController < ApplicationController
  def index
    @tournaments =
      case params[:filter]
      when 'before-today'
        Tournament.before_today.order(created_at: :desc)
      else
        Tournament.today.order(created_at: :desc)
      end
  end
end
