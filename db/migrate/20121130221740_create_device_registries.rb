class CreateDeviceRegistries < ActiveRecord::Migration
  def change
    create_table :device_registries do |t|
        t.string :device_guid
        t.string :device_id
        t.string :device_agent_id
        t.string :device_agent_guid
        t.string :network_address
        t.string :physical_location
        t.timestamps
    end
  end
end
