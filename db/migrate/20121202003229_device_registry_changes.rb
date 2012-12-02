class DeviceRegistryChanges < ActiveRecord::Migration
  def up
    add_column :devices, :device_agent_id, :integer
    add_column :devices, :device_agent_guid, :string

    add_column :device_agents, :device_id, :integer
    add_column :device_agents, :device_guid, :string

    drop_table :device_registries
  end

  def down
    create_table :device_registries do |t|
        t.string :device_guid
        t.string :device_id
        t.string :device_agent_id
        t.string :device_agent_guid
        t.string :network_address
        t.string :physical_location
        t.timestamps
    end
    remove_column :devices, :device_agent_id
    remove_column :devices, :device_agent_guid

    remove_column :device_agents, :device_guid
    remove_column :device_agents, :device_id
  end
end
