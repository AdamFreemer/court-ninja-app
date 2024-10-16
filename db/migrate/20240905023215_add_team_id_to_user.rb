class AddTeamIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :teams, :string, array: true, default: []
  end
end
