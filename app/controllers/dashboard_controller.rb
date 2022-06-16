class DashboardController < ApplicationController
  def index
    @teams = current_user.teams_coached if current_user.is_coach?
    @tournaments =
      case params[:filter]
      when 'before-today'
        Tournament.before_today.order(created_at: :desc)
      else
        Tournament.today.order(created_at: :desc)
      end
  end
end
