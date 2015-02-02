class AddDeviceRegIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :device, :string
    add_column :users, :reg_id, :string
  end
end
