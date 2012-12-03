class DeviceType < ActiveRecord::Base
    attr_accessible :device_type, :version, :manufacturer, :metadata
    has_many :devices
end
