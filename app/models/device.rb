class Device < ActiveRecord::Base
    attr_accessible :guid, :uri, :device_type_id, :network_address, :metadata_json, :print_name, :config

    #has_many :device_registries
    has_and_belongs_to_many :device_agents
    belongs_to :device_type
    has_one :location, :dependent => :destroy
    has_many :sensors, :dependent => :destroy

    def as_json(options={})
      {
        :uri => self.uri,
        :sensors => self.sensors
      }
    end

    before_create do
        self.guid = SecureRandom.uuid
    end

end
