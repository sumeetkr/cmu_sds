class CreateSensorTypeRegistries < ActiveRecord::Migration
  def change
    create_table :sensor_type_registries do |t|

      t.timestamps
    end
  end
end
