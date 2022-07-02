class AddTournamentConfigurationFields < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :configuration, :string
    change_column_default :tournaments, :current_round, 0
  end
end
