class CreateUserRoleRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :user_role_requests do |t|
      t.references :user, foreign_key: true
      t.string :status, default: 'pending'
      t.references :processed_by, foreign_key: { to_table: :users }
      t.datetime :processed_at

      t.timestamps
    end

    create_table(:user_role_requests_roles, :id => false) do |t|
      t.references :user_role_request
      t.references :role
    end

    add_index(:user_role_requests_roles, [ :user_role_request_id, :role_id ], name: 'index_user_role_requests_roles_on_user_role_request_and_role')
  end
end

