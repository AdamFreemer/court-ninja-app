class AddCreatedByToTournament < ActiveRecord::Migration[7.0]
  def change
    add_reference :tournaments, :created_by, foreign_key: { to_table: :users }
  end
end
