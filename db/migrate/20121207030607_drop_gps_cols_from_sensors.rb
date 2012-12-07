class DropGpsColsFromSensors < ActiveRecord::Migration
  def change
	remove_column :sensors, :gps_coord_lat
  	remove_column :sensors, :gps_coord_lon
  	remove_column :sensors, :gps_coord_alt
  end
end
