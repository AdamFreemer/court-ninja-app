class CreateTeamUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :team_users do |t|
      t.integer :team_id
      t.integer :user_id

      t.timestamps
    end
  end
end
