class DeviceRegistry < ActiveRecord::Base
    belongs_to :device
    belongs_to :device_agent
  # attr_accessible :title, :body
end
