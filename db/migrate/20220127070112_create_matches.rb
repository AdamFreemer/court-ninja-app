class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.string :zip
      t.integer :number
      t.integer :tournament_id
      t.integer :court

      t.timestamps
    end
  end
end
