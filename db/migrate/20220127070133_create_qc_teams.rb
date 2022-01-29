class CreateQcTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :qc_teams do |t|

      t.timestamps
    end
  end
end
