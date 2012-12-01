class SensorType < ActiveRecord::Base
    has_many :sensors
  # attr_accessible :title, :body
end
