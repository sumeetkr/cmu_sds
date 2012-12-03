class RenamingColumnTypeToPropertyTypeInSensorType < ActiveRecord::Migration
  def up
    rename_column :sensor_types, :type, :property_type
    rename_column :device_types, :type, :device_type
  end

  def down
    # rename back if you need or do something else or do nothing
  end
end
