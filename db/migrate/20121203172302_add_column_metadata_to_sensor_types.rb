class AddColumnMetadataToSensorTypes < ActiveRecord::Migration
  def change
    add_column :sensor_types, :metadata, :string
  end
end
