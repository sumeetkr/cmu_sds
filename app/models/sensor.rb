class Sensor < ActiveRecord::Base
  attr_accessible :guid, :uri, :sensor_type_id, :min_value, :max_value, :device_guid, :device_id, :predecessor, :metadata_json, :location
  belongs_to :device
  belongs_to :sensor_type
  has_one :location
end
