class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.string :zip
      t.integer :number
      t.integer :court
      t.integer :round
      t.integer :tournament_id
      t.integer :ghost_players, default: 0

      t.timestamps
    end
  end
end
