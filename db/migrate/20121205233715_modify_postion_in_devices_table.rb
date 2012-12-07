class ModifyPostionInDevicesTable < ActiveRecord::Migration
  def change
	add_column :devices, :print_name, :string
  end
end