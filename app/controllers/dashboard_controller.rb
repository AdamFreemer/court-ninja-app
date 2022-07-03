class DashboardController < ApplicationController
  def index
    if current_user.is_coach?
      @teams = current_user.teams_coached if current_user.is_coach?
      @tournaments =
        case params[:filter]
        when 'before-today'
          Tournament.where(created_by_id: current_user.id).before_today.order(created_at: :desc)
        else
          Tournament.where(created_by_id: current_user.id).today.order(created_at: :desc)
        end
    else
      @tournaments =
        case params[:filter]
        when 'before-today'
          Tournament.before_today.order(created_at: :desc)
        else
          Tournament.today.order(created_at: :desc)
        end
    end
  end
end
