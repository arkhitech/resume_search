class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :summary
      t.references :description, polymorphic: true, index: true

      t.timestamps
    end
  end
end
