class AddNewTournamentTimerFields < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :match_time, :integer
    add_column :tournaments, :pre_match_time, :integer
    add_column :tournaments, :admin_views, :json, default: {}
    add_column :tournaments, :admin_view_current, :integer
  end
end
