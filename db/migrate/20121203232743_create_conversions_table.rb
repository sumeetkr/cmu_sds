class CreateConversionsTable < ActiveRecord::Migration
  def change
    create_table(:conversions) do |t|
      t.integer :device_type_id
      t.string :quantity
      t.text :description
      t.string :conversion_type
      t.float :a
      t.float :b
      t.string :chart_min
      t.string :chart_max
      t.timestamps
    end
  end
end
