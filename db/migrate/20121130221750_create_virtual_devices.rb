class CreateVirtualDevices < ActiveRecord::Migration
  def change
    create_table :virtual_devices do |t|
        t.string :guid
        t.string :desc
        t.timestamps
    end
  end
end
