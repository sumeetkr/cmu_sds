require "aws"

class SensorReadingsController < ApplicationController
  respond_to :html, :json

  def show
    render :text => "Hi", :status => 200, :content_type => 'text/html'
  end

  def create
    #reading_json = params[:reading]
    reading_json = request.body.read
    reading_hash = JSON.parser(reading_json)
    TABLES[sensor_readings_table_name].items.create(reading_hash)
    render :text => "Success", :status => 200, :content_type => 'text/html'
  end

end
