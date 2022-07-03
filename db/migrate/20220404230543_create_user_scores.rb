class CreateUserScores < ActiveRecord::Migration[7.0]
  def change
    create_table :user_scores do |t|
      t.references :user, foreign_key: true
      t.references :tournament_set, foreign_key: true
      t.references :tournament_team, foreign_key: true
      t.references :tournament, foreign_key: true
      t.integer :score
      t.integer :court
      t.integer :round
      t.integer :win
      t.integer :loss

      t.timestamps
    end
  end
end
