class AddUrlToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :url, :string
  end
end
