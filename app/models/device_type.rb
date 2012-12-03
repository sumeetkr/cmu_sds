class DeviceType < ActiveRecord::Base
    attr_accessible :device_type, :version, :manufacturer
    has_many :devices
end
