class AddTeamToTournaments < ActiveRecord::Migration[7.0]
  def change
    add_reference :tournaments, :base_team, foreign_key: { to_table: :teams }
  end
end
