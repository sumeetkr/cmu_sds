class RenameAllColumnMetadataToMetadataJson < ActiveRecord::Migration
  def up
    rename_column :device_agents, :metadata, :metadata_json
    rename_column :device_types, :metadata, :metadata_json
    rename_column :devices, :metadata, :metadata_json
    rename_column :sensor_types, :metadata, :metadata_json
    rename_column :sensors, :metadata, :metadata_json
  end

  def down
    # rename back if you need or do something else or do nothing
  end
end
