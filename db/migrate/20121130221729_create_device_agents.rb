class CreateDeviceAgents < ActiveRecord::Migration
  def change
    create_table :device_agents do |t|
        t.string :guid
        t.string :metadata
        t.string :network_address
        t.string :device_name
        t.timestamps
    end
  end
end
