class Sensor < ActiveRecord::Base
  attr_accessible :guid

  belongs_to :device
  belongs_to :sensor_type
end
