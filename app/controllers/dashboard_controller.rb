class DashboardController < ApplicationController
  before_action :set_params

  def index
    @tournaments = Tournament.all.order(created_at: :desc)
    @tournaments = @tournaments.where(created_by_id: current_user.id) if current_user.is_coach?
    if current_user.is_coach?
      @teams = current_user.teams_coached if current_user.is_coach?
    else
      @teams = current_user.teams
    end
  end

  def landing
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
