class AddCourtSideNames < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :court_side_a_name, :string
    add_column :tournaments, :court_side_b_name, :string
  end
end
