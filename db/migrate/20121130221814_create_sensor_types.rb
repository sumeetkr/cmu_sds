class CreateSensorTypes < ActiveRecord::Migration
  def change
    create_table :sensor_types do |t|
        t.string :type
        t.timestamps
    end
  end
end
