class SensorType < ActiveRecord::Base
    attr_accessible :property_type
    has_many :sensors
end
