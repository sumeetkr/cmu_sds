class ChangeColumnNamePhysicalLocInDeviceAgent < ActiveRecord::Migration
	def up
		rename_column :device_agents, :physical_location, :print_name
	end
	def down
		# rename back if you need or do something else or do nothing
	end
end