class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :devices, :configurations, :config
  end

  def down
  end
end
