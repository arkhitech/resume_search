class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.string :name
      t.string :description
      t.integer :person_id

      t.timestamps
    end
  end
end
