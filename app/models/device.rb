class Device < ActiveRecord::Base
    attr_accessible :guid, :device_type_id, :device_agent_id, :network_address, :physical_location

    #has_many :device_registries
    has_and_belongs_to_many :device_agents
    belongs_to :device_type
    has_many :sensors

    def as_json(options={})
      {
        :guid => self.guid,
        :sensors => self.sensors
      }
    end

end
