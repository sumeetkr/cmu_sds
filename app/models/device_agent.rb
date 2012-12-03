class DeviceAgent < ActiveRecord::Base
  attr_accessible :guid, :network_address, :physical_location, :metadata_json
  has_and_belongs_to_many :devices
end
