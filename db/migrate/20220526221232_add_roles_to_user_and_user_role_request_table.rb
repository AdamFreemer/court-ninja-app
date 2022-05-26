class AddRolesToUserAndUserRoleRequestTable < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :player, :boolean, default: false
    add_column :users, :coach, :boolean, default: false
    add_column :users, :tournament_organizer, :boolean, default: false

    create_table :user_role_requests do |t|
      t.references :user, foreign_key: true
      t.string :role
      t.string :status, default: 'pending'
      t.references :processed_by, foreign_key: { to_table: :users }
      t.datetime :processed_at

      t.timestamps
    end
  end
end
