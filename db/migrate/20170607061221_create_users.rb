class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.string :name
      t.string :email, unique: true
      
      t.timestamps null: false
    end
  end
end
