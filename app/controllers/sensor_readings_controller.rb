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
    json_array = []

    if !params[:startTime].blank? && !params[:endTime].blank?
      startTime = params[:startTime].to_i
      endTime = params[:endTime].to_i
      # The query method requires a hash_value
      @sensor_reading_table.items.query(
          :hash_value => id,
          :range_value => startTime..endTime,
          :select => [:id, :temp, :timestamp]).each do |reading|
        process_reading(json_array, reading)
      end
    else
      @sensor_reading_table.items.query(
          :hash_value => id,
          :select => [:id, :temp, :timestamp]).each do |reading|
        process_reading(json_array, reading)
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

  def process_reading(json_array, reading)
    run_conversions(reading)
    json_array << convert_reading_to_json(reading)
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

  def convert_reading_to_json(reading)
    {:id => reading.attributes["id"],
     :temp => reading.attributes["temp"],
     :timestamp => reading.attributes["timestamp"]
    }
  end

end