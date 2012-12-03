class SensorType < ActiveRecord::Base
    attr_accessible :property_type, :metadata
    has_many :sensors
end
