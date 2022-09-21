class AddTournamentTotalTime < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :total_tournament_time, :float
    add_column :tournaments, :matches_per_round, :integer
  end
end
