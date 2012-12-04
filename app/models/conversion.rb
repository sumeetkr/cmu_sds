class Conversion < ActiveRecord::Base
  attr_accessible :device_type_id, :quantity, :description, :conversion_type, :a, :b, :chart_min, :chart_max

  belongs_to :device_type

end