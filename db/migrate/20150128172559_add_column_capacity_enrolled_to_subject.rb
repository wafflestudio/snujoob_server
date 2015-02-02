class AddColumnCapacityEnrolledToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :capacity_enrolled, :integer
  end
end
