class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
        t.string :guid
        t.string :metadata
        t.string :sensor_type_id
        t.integer :min_value
        t.integer :max_value
        t.timestamps
    end
  end
end
