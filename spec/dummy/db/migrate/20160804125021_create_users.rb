class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.string :employee_number
      t.integer :organization_id
      t.string :role

      t.timestamps null: false
    end
  end
end
