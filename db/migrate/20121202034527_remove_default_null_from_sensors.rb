class RemoveDefaultNullFromSensors < ActiveRecord::Migration
  def up
    # remove_column :sensors, :predecessor, :string, :default => null
    # add_column :sensors, :predecessor, :string
    change_column_default(:sensors, :predecessor, nil)
  end

  def down
    # add_column :sensors, :predecessor, :string, :default => null
    # remove_column :sensors, :predecessor, :string, :default => null
    change_column_default(:sensors, :predecessor, null)
  end
end