class Location < ActiveRecord::Base
  attr_accessible :alt, :format, :lat, :lon, :print_name
end
