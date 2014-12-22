class CreateCompetencies < ActiveRecord::Migration
  def change
    create_table :competencies do |t|
      t.text :description
      t.string :name
      t.integer :skill_level
      t.string :skill_proficiency
      t.references :resume

      t.timestamps
    end
  end
end
