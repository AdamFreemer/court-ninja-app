class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.text :description
      t.string :invite_code
      t.boolean :active, default: true
      t.references :coach, index: true, foreign_key: { to_table: :users }
      t.timestamps
    end

    create_table :player_teams do |t|
      t.references :team, foreign_key: true
      t.references :player, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
