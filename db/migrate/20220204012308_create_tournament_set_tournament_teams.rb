class CreateTournamentSetTournamentTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_set_tournament_teams do |t|
      t.references :tournament_set, foreign_key: true
      t.references :tournament_team, foreign_key: true

      t.timestamps
    end
  end
end
