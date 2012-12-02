class SensorsController < ApplicationController

    def new
        if (!params[:guid].blank? && !params[:device_id].blank?)
            @sensor = Sensor.new(:guid => params[:guid], :device_id => params[:device_id])
            @sensor.sensor_type_id = params[:sensor_type_id] unless params[:sensor_type_id].blank?
            @sensor.min_value = params[:min_value] unless params[:min_value].blank?
            @sensor.max_value = params[:max_value] unless params[:max_value].blank?
            @sensor.device_guid = params[:device_guid] unless params[:device_guid].blank?
            @sensor.predecessor = params[:predecessor] unless params[:predecessor].blank?
            @sensor.metadata = params[:metadata] unless params[:metadata].blank?
            @sensor.gps_coord_lat = params[:gps_coord_lat] unless params[:gps_coord_lat].blank?
            @sensor.gps_coord_long = params[:gps_coord_long] unless params[:gps_coord_long].blank?
            @sensor.gps_coord_alt = params[:gps_coord_alt] unless params[:gps_coord_alt].blank?
            @sensor.save
            #redirect_to sensors_url
        else
            @sensor = Sensor.new
                respond_to do |format|
                format.html # new.html.erb
                format.json { render json: @sensor }
            end
        end
    end
    def create
        @sensor = Sensor.new(params[:sensor])
        if @sensor.save
            flash[:notice] = "Sensor created successfully !"
            redirect_to :action => "index"
        else
            flash[:error] = "Couldn't create the Sensor. Please try again."
            render "new"
        end
    end


    def index
        @sensors = Sensor.all
    end

    def edit
        @sensor = Sensor.find(params[:id])
    end

end
