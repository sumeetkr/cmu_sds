class AddLocationRefToDevicesSensorsDeviceTypes < ActiveRecord::Migration
  def change
  	add_column :devices, :location_id, :integer
  	add_column :sensors, :location_id, :integer
  	add_column :device_agents, :location_id, :integer
  	add_column :locations, :device_id, :integer
  	add_column :locations, :sensor_id, :integer
  	add_column :locations, :device_agent_id, :integer
  end
end
