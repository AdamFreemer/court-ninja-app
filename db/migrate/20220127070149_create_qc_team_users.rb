class CreateQcTeamUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :qc_team_users do |t|
      t.integer :qc_team_id
      t.integer :user_id

      t.timestamps
    end
  end
end
