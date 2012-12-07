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
      run_conversions(reading)
      json_array << {
          :id => id,
          :temp => reading.attributes["temp"],
          :timestamp => reading.attributes["timestamp"]
      }
    end

    render :json => json_array
  end

  def show
    id = params[:id]
    start_time = params[:start_time].to_i
    end_time = params[:end_time].to_i
    number_of_tuples = params[:tuples].to_i

    if end_time > 0
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

    # Convert the Enumerator to an Array so that we can index into it.
    # Enumerator.find(id) returns another Enumerator that does not
    # have the expected 'attributes' hash
    readings = readings.to_a

    readings.each do |reading|
      run_conversions(reading)
    end

    json_array = []

    if number_of_tuples > 0
      number_of_readings = readings.count
      readings_per_tuple = (number_of_readings / number_of_tuples).to_i
      if readings_per_tuple > 0
        number_of_tuples.times do |tuple_index|
          start_index = tuple_index * readings_per_tuple
          end_index = start_index + readings_per_tuple
          tuple_readings = readings[start_index..end_index]
          tuple_timestamps = tuple_readings.collect { |r| r.attributes["timestamp"] }
          tuple_temp_readings = tuple_readings.collect { |r| r.attributes["temp"] }
          json_array << {
              :id => id,
              :average_timestamp => tuple_timestamps.average,
              :first => tuple_temp_readings.first,
              :last => tuple_temp_readings.last,
              :min => tuple_temp_readings.min,
              :max => tuple_temp_readings.max,
              :average => tuple_temp_readings.average
          }
        end
      end
    else
      readings.each do |reading|
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