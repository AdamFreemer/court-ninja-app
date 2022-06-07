class CreateUserTraits < ActiveRecord::Migration[7.0]
  def change
    create_table :user_traits do |t|
      t.references :user, foreign_key: true
      t.references :trait, foreign_key: true

      t.timestamps
    end
  end
end
