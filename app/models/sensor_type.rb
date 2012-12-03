class SensorType < ActiveRecord::Base
    attr_accessible :property_type, :metadata_json
    has_many :sensors
end
