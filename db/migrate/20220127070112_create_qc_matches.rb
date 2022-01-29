class CreateQcMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :qc_matches do |t|
      t.string :zip
      t.integer :number
      t.integer :qc_team_0_id
      t.integer :qc_team_1_id
      t.integer :qc_team_0_score
      t.integer :qc_team_1_score
      t.integer :tournament_id

      t.timestamps
    end
  end
end
