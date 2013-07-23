class AddConfigurationToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :configurations, :text
  end
end
