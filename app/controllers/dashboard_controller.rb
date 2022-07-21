class DashboardController < ApplicationController
  before_action :set_params

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
      @teams = current_user.teams
      @tournaments =
        case params[:filter]
        when 'before-today'
          Tournament.before_today.order(created_at: :desc)
        else
          Tournament.today.order(created_at: :desc)
        end
    end
  end

  private

  def set_params
    @positions = [
      ['Setter (S)', 1],
      ['Outside Hitter (OH)', 2],
      ['Opposite/Right Side Hitter (OPPO/RS)', 3],
      ['Middle (M)', 3],
      ['Libero (LIB)', 4],
      ['Defensive Specialist (DS)', 5]
    ]
  end
end
