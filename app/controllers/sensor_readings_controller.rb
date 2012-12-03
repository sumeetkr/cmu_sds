require "aws"

class SensorReadingsController < ApplicationController
  respond_to :html, :json
  before_filter :initialize_dynmodb

  def index
    readings_json = []

    if params.has_key?(:startTime) && params.has_key?(:endTime)
      startTime = params[:startTime].to_i
      endTime = params[:endTime].to_i
      @sensor_reading_table.items.query(
          :hash_value => "1",
          :range_value => startTime..endTime,
          :select => [:id, :temp, :timestamp]).each do |reading|
        readings_json << {:id => reading.attributes["id"],
                          :temp => reading.attributes["temp"],
                          :timestamp => reading.attributes["timestamp"]
        }
      end
    else
      @sensor_reading_table.items.each do |reading|
        readings_json << {:id => reading.attributes["id"],
                          :temp => reading.attributes["temp"],
                          :timestamp => reading.attributes["timestamp"]
        }
      end
    end

    render :json => readings_json
  end

  def show
    render :text => "Hi", :status => 200, :content_type => 'text/html'
  end

  def create
    reading_json = request.body.read
    reading_hash = ActiveSupport::JSON.decode(reading_json)

    @sensor_reading_table.items.create(reading_hash)
    render :text => "Success", :status => 200, :content_type => 'text/html'
  end

  def initialize_dynmodb
    sensor_readings_table_name = "SensorReadingV3"
    db = AWS::DynamoDB.new
    @sensor_reading_table = db.tables[sensor_readings_table_name].load_schema
  end
end
