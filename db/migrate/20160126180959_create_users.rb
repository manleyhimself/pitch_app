class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :gender
      t.string :password
      t.string :university
      t.string :job_title
      t.string :company_name
      t.string :blurb
      t.date :birthday

      t.timestamps null: false
    end
  end
end
