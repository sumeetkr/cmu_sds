class ChangeSensorDeviceIdTypeToInteger < ActiveRecord::Migration
  def change
    change_column :sensors, :device_id, :integer
  end
end
