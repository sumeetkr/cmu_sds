class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :alt
      t.string :format
      t.string :lat
      t.string :lon
      t.string :print_name

      t.timestamps
    end
  end
end
