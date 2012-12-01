class CreateVirtualSensors < ActiveRecord::Migration
  def change
    create_table :virtual_sensors do |t|
        t.string :guid
        t.string :desc
        t.timestamps
    end
  end
end
