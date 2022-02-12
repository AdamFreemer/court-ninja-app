class CreateTournaments < ActiveRecord::Migration[7.0]
  def change
    create_table :tournaments do |t|
      t.string   :name
      t.string   :address1
      t.string   :address2
      t.string   :city
      t.string   :state
      t.string   :zip
      t.datetime :date
      t.integer :courts
      t.boolean :configured, default: false
      t.string :players, array: true, default: []

      t.timestamps
    end
  end
end
