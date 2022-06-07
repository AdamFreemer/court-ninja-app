class CreateTournamentTeamUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_team_users do |t|
      t.references :tournament_team, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
