class CreateResumes < ActiveRecord::Migration
  def change
    create_table :resumes do |t|
      t.string :name
      t.string :telephone
      t.string :email
      t.string :country
      

      t.timestamps
    end
  end
end
