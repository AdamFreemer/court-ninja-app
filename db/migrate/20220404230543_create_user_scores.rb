class CreateUserScores < ActiveRecord::Migration[7.0]
  def change
    create_table :user_scores do |t|
      t.integer :user_id
      t.integer :match_id
      t.integer :team_id
      t.integer :tournament_id
      t.integer :score
      t.integer :court
      t.integer :round
      t.string :win_loss

      t.timestamps
    end
  end
end
