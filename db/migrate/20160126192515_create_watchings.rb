class CreateWatchings < ActiveRecord::Migration
  def change
    create_table :watchings do |t|
      t.integer :lecture_id
      t.integer :user_id
      t.boolean :watch, default: true

      t.timestamps null: false
    end
  end
end
