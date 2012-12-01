class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
        t.string :guid
        t.string :device_type_id
        t.string :metadata
        t.timestamps
    end
  end
end
