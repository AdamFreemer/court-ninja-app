class CreateTournamentTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_teams do |t|
      t.timestamps
      t.references :tournament, foreign_key: true
      t.integer :number
      t.integer :score
      t.boolean :work_team
    end
  end
end
