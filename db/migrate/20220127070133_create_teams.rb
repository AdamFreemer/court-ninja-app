class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.timestamps

      t.integer :score
    end
  end
end
