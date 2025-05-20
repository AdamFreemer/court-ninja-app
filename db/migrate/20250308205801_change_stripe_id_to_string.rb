class ChangeStripeIdToString < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :stripe_id, :string
  end

  def down
    change_column :users, :stripe_id, :integer
  end
end