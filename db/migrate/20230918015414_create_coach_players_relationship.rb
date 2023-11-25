class CreateCoachPlayersRelationship < ActiveRecord::Migration[7.0]
  def change
    create_table :coach_players_relationships do |t|
      def change
        create_table :employees do |t|
          t.references :manager, foreign_key: { to_table: :employees }
          t.timestamps
        end
      end
      t.timestamps
    end
  end
end
