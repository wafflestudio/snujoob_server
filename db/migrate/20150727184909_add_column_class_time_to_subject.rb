class AddColumnClassTimeToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :class_time, :string
  end
end
