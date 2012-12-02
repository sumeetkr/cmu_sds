class AddDeviceToDeviceAgentRelationship < ActiveRecord::Migration
  def change
    create_table :device_agents_devices do |t|
        t.integer :device_id
        t.integer :device_agent_id
    end
  end
end