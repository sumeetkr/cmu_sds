class DropDeviceIdFromDeviceAgents < ActiveRecord::Migration
  def up
	remove_column :device_agents, :device_id
	remove_column :devices, :device_agent_id
  end
  def down
	add_column :device_agents, :device_id, :string
	add_column :devices, :device_agent_id, :string
  end
end
