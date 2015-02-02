class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :subject_name
      t.string :subject_number
      t.string :lecture_number
      t.string :lecturer
      t.integer :capacity
      t.integer :enrolled

      t.timestamps
    end
  end
end
