class DeviceType < ActiveRecord::Base
    attr_accessible :device_type, :version, :manufacturer, :metadata_json
    has_many :devices
end
