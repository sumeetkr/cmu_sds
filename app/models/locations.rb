class Locations < ActiveRecord::Base
	attr_accessible :alt, :format, :lat, :lon, :print_name
	belongs_to :device
	belongs_to :sensor
	belongs_to :device_agent
end
