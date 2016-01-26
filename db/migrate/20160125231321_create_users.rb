class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :student_id, null: false
      t.string :password, null: false
      t.string :salt, null: false
      t.string :gcm_token
      t.string :login_token

      t.timestamps null: false
    end
  end
end
