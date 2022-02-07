class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.timestamps

      t.integer :number
      t.integer :score
      t.integer :tournament_id
    end
  end
end
