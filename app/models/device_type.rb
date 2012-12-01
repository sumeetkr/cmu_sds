class DeviceType < ActiveRecord::Base
    has_many :devices
  # attr_accessible :title, :body
end
