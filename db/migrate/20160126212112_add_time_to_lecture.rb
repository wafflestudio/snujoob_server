class AddTimeToLecture < ActiveRecord::Migration
  def change
    add_column :lectures, :time, :string
  end
end
