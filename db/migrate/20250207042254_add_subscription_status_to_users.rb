class AddSubscriptionStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :subscription_status, :string
  end
end
