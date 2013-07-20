class Sensor < ActiveRecord::Base
  attr_accessible :guid, :uri, :sensor_type_id, :min_value, :max_value, :device_guid, :device_id, :predecessor, :metadata_json, :location, :frequency
  belongs_to :device
  belongs_to :sensor_type
  has_one :location, :dependent => :destroy

	before_create do
	    self.guid = SecureRandom.uuid
	end
end