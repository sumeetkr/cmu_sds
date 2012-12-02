class DeviceAgent < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :device_registries
  has_many :devices, :through => :device_registries
end
