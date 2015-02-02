class CreateSubjectsUsersJoinTables < ActiveRecord::Migration
  def change
  	create_table :subjects_users, id: false do |t|
			t.integer :subject_id
			t.integer :user_id
		end

		add_index :subjects_users, :subject_id
		add_index :subjects_users, :user_id
  end
end
