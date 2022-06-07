class CreateMatchTournamentTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :match_tournament_teams do |t|
      t.references :match, foreign_key: true
      t.references :tournament_team, foreign_key: true

      t.timestamps
    end
  end
end
