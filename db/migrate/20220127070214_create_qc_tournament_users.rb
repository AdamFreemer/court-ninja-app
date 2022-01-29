class CreateQcTournamentUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :qc_tournament_users do |t|
      t.integer :qc_tournament_id
      t.integer :user_id

      t.timestamps
    end
  end
end
