class AddSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :subscribed, :boolean, default: false
    add_column :users, :subscription_plan, :integer, default: 0
    add_column :users, :stripe_id, :integer
  end
end
