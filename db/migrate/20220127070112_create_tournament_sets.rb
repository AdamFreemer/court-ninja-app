class CreateTournamentSets < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_sets do |t|
      t.references :tournament, foreign_key: true
      t.string :zip
      t.integer :number
      t.integer :court
      t.integer :round
      t.integer :ghost_players, default: 0

      t.timestamps
    end
  end
end
