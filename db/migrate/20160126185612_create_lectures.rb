class CreateLectures < ActiveRecord::Migration
  def change
    create_table :lectures do |t|
      t.string :subject_number, null: false
      t.string :lecture_number, null: false
      t.string :lecturer, defalut: ''
      t.string :name
      t.integer :enrolled
      t.integer :whole_capacity
      t.integer :enrolled_capacity

      t.timestamps null: false
    end
  end
end
