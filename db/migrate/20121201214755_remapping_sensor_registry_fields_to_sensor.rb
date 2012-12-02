class RemappingSensorRegistryFieldsToSensor < ActiveRecord::Migration
  def up
    drop_table :sensor_registries

    add_column :sensors, :device_guid, :string
    add_column :sensors, :device_id, :string
    add_column :sensors, :predecessor, :string, :default => :null

    add_column :devices, :network_address, :string
    add_column :devices, :physical_location, :string
  end

  def down
    create_table :sensor_registries do |t|
        t.string :sensor_guid
        t.string :sensor_id
        t.string :device_guid
        t.string :device_id
        t.string :network_address
        t.string :physical_location
        t.string :predecessor, :default => :null
        t.timestamps
    end
  end
end
