class CreateDeviceAgents < ActiveRecord::Migration
  def change
    create_table :device_agents do |t|
        t.string :guid
        t.string :metadata
        t.string :network_address
        t.string :physical_location
        t.timestamps
    end
  end
end
