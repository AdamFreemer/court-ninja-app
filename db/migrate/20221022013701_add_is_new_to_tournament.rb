class AddIsNewToTournament < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :is_new, :boolean, default: true
  end
end
