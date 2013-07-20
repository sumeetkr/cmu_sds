class AddFrequencyToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :frequency, :integer
  end
end
