require "aws"

class SensorReadingsController < ApplicationController
  respond_to :html, :json

  def show
    render :text => "Hi", :status => 200, :content_type => 'text/html'
  end

  def create
    #reading_json = params[:reading]
    reading_json = request.body.read
    reading_hash = ActiveSupport::JSON.decode(reading_json)

    sensor_readings_table_name = "SensorReadingV2"
    db = AWS::DynamoDB.new
    sensor_reading_table = db.tables[sensor_readings_table_name].load_schema
    sensor_reading_table.items.create(reading_hash)
    render :text => "Success", :status => 200, :content_type => 'text/html'
  end

end
