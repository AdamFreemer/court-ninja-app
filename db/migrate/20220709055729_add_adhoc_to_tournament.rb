class AddAdhocToTournament < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :adhoc, :boolean, default: false
    add_column :users, :adhoc, :boolean, default: false
    add_column :users, :nick_name, :string
  end
end
