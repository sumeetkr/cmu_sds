class RenameGuidColsToUriAndAddNewGuidCols < ActiveRecord::Migration
  def up
  	rename_column :device_agents, :guid, :uri
  	rename_column :devices, :guid, :uri
  	rename_column :sensors, :guid, :uri
  	
  	add_column :device_agents, :guid, :string
  	add_column :devices, :guid, :string
  	add_column :sensors, :guid, :string
  end

  def down
  	remove_column :device_agents, :guid, :string
  	remove_column :devices, :guid, :string
  	remove_column :sensors, :guid, :string

  	rename_column :device_agents, :uri, :guid
  	rename_column :devices, :uri, :guid
  	rename_column :sensors, :uri, :guid
  end
end
