class Sensor < ActiveRecord::Base
  attr_accessible :guid, :sensor_type_id, :min_value, :max_value, :device_guid, :device_id, :predecessor, :gps_coord_lat, :gps_coord_long, :gps_coord_alt, :metadata

  belongs_to :device
  belongs_to :sensor_type
end
