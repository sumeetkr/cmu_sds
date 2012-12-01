class CreateSensorRegistries < ActiveRecord::Migration
  def change
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
