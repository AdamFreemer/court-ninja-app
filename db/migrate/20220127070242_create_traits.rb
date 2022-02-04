class CreateTraits < ActiveRecord::Migration[7.0]
  def change
    create_table :traits do |t|
      t.string :name
      t.string :description
      t.boolean :is_objective?
      t.boolean :is_subjective?

      t.timestamps
    end
  end
end
