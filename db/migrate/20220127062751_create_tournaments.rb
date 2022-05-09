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
      t.string :court_1_name
      t.string :court_2_name
      t.string :court_3_name
      t.string :court_4_name
      t.string :court_5_name
      t.string :court_6_name
      t.integer :rounds
      t.integer :team_size
      t.integer :work_group
      t.integer :rounds_configured, array: true, default: []
      t.integer :rounds_finalized, array: true, default: []
      t.integer :players, array: true, default: []
      t.string :court_names, array: true, default: []
      t.integer :time
      t.integer :current_set, default: 1

      t.timestamps
    end
  end
end
