class CreateDeviceTypes < ActiveRecord::Migration
  def change
    create_table :device_types do |t|
        t.string :type
        t.string :version
        t.string :manufacturer
        t.string :metadata, :limit => 1024
        t.timestamps
    end


  end
end
