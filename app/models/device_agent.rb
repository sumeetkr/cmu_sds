class DeviceAgent < ActiveRecord::Base
	attr_accessible :guid, :uri, :network_address, :print_name, :metadata_json
	has_and_belongs_to_many :devices
	has_one :location, :dependent => :destroy

  	before_create do
	    self.guid = SecureRandom.uuid
	end
end
