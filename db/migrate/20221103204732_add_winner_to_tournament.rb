class AddWinnerToTournament < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :winner_id, :integer, default: 0
  end
end
