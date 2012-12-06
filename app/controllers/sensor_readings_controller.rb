require "aws"

class SensorReadingsController < ApplicationController
  respond_to :html, :json
  before_filter :initialize_dynmodb

  def index
    json_array = []

    # This is incredibly slow because it gets EVERYTHING.
    # It is not optimized like the query method.
    # I did not use query(..) because it requires a hash_value
    @sensor_reading_table.items.each do |reading|
      process_reading(json_array, reading)
    end

    render :json => json_array
  end

  def show
    id = params[:id]
    start_time = params[:startTime].to_i
    end_time = params[:endTime].to_i
    number_of_tuples = params[:tuples].to_i

    if !start_time.blank? && !end_time.blank?
      # The query method requires a hash_value
      readings = @sensor_reading_table.items.query(
          :hash_value => id,
          :range_value => start_time..end_time,
          :select => [:id, :temp, :timestamp])
    else
      readings = @sensor_reading_table.items.query(
          :hash_value => id,
          :select => [:id, :temp, :timestamp])
    end

    json_array = []

    if !number_of_tuples.blank?

      temp_values = []
      readings.each do |reading|
        run_conversions(reading)
        temp_values << reading.attributes["temp"]
      end

      number_of_readings = readings.count
      readings_per_tuple = (number_of_readings / number_of_tuples).to_i

      number_of_tuples.times do |tuple_index|
        start_index = tuple_index * readings_per_tuple
        end_index = start_index + readings_per_tuple
        tuple_values = temp_values[start_index..end_index]
        json_array << {
            :id => id,
            :timestamp => average([start_time, end_time]),
            :first => tuple_values.first,
            :last => tuple_values.last,
            :min => tuple_values.min,
            :max => tuple_values.max,
            :average => average(tuple_values)
        }

      end

    else
      readings.each do |reading|
        run_conversions(reading)
        json_array << {
            :id => id,
            :temp => reading.attributes["temp"],
            :timestamp => reading.attributes["timestamp"]
        }
      end
    end

    render :json => json_array
  end

  def create
    reading_json = request.body.read
    reading_hash = ActiveSupport::JSON.decode(reading_json)

    if (reading_hash.is_a? Array)
      @sensor_reading_table.batch_write(
          :put => reading_hash
      )
    else
      @sensor_reading_table.items.create(reading_hash)
    end

    render :text => "Success", :status => 200, :content_type => 'text/html'
  end

  def initialize_dynmodb
    sensor_readings_table_name = "SensorReadingV3"
    db = AWS::DynamoDB.new
    @sensor_reading_table = db.tables[sensor_readings_table_name].load_schema
  end

  private

  def average(array)
    array.sum / array.length
  end

  def run_conversions(reading)
    ["temp"].each do |type|
      value = reading.attributes[type]
      reading.attributes[type] = convert(value, type)
    end
  end

  def convert(x, type)
    # 'x' must be an integer to be used in equations
    x = x.to_i
    conversion = Conversion.find_by_quantity(type)
    a = conversion.a
    b = conversion.b
    return a * x + b
  end

end