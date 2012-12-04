class AddingDefaultConfigToDeviceTypes < ActiveRecord::Migration
  def change
    add_column :device_types, :default_config, :string
  end
end
