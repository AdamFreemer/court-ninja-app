class CreateMatchTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :match_teams do |t|
      t.integer :match_id
      t.integer :team_id

      t.timestamps
    end
  end
end
