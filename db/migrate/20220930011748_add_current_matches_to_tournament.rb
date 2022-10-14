class AddCurrentMatchesToTournament < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :current_matches, :json, default: {}
  end
end
