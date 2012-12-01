class AddGpsLocToSensorAndSensorIdToDevices < ActiveRecord::Migration
  def change
    add_column :sensors, :gps_coord_lat, :integer
    add_column :sensors, :gps_coord_long, :integer
    add_column :sensors, :gps_coord_alt, :integer

    add_column :devices, :sensor_id, :integer
  end
end
