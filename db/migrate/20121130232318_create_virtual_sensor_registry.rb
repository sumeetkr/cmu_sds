class CreateVirtualSensorRegistry < ActiveRecord::Migration
    def change
      create_table :virtual_sensor_registries do |t|
            t.string :virtual_sensor_id
            t.string :sensor_id
            t.timestamps
      end
    end
end