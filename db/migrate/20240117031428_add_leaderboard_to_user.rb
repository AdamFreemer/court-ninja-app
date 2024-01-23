class AddLeaderboardToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_on_leaderboard, :boolean, default: true
  end
end
