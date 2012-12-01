require "aws"

class SensorReadingsController < ApplicationController
  respond_to :html, :json
  before_filter :initialize_dynmodb


  def show
    render :text => "Hi", :status => 200, :content_type => 'text/html'
  end

  def create
    #reading_json = params[:reading]
    reading_json = request.body.read
    reading_hash = ActiveSupport::JSON.decode(reading_json)

    @sensor_reading_table.items.create(reading_hash)
    render :text => "Success", :status => 200, :content_type => 'text/html'
  end

  def index
    id = params[:id]

    readings_json = []

    @sensor_reading_table.items.each do |reading|
      readings_json << {:id => reading.attributes["id"],
                        :temp => reading.attributes["temp"],
                        :timestamp => reading.attributes["timestamp"]
      }

    end

    render :json => readings_json
  end

  def initialize_dynmodb
    sensor_readings_table_name = "SensorReadingV3"
    db = AWS::DynamoDB.new
    @sensor_reading_table = db.tables[sensor_readings_table_name].load_schema
  end
end
