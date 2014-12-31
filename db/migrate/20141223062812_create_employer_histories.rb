class CreateEmployerHistories < ActiveRecord::Migration
  def change
    create_table :employer_histories do |t|
      t.string :organization_name
      t.references :resume, index: true
      t.references :description, polymorphic: true, index: true
      t.string :title
      t.string :country_code
      t.string :start_date
      t.string :end_date
      t.string :months_of_work

      t.timestamps
    end
  end
end
