class Device < ActiveRecord::Base
    has_many :device_registries
    has_many :device_agents, :through => :device_registries
    belongs_to :device_type
    has_many :sensors
  # attr_accessible :title, :body
end
