class AddPendingToPlayerTeams < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'uuid-ossp'

    add_column :player_teams, :pending, :boolean, default: false
    add_column :player_teams, :uuid, :uuid, default: "uuid_generate_v4()", null: false
  end
end
