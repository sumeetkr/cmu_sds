class SensorsController < ApplicationController
    respond_to :json, :html

    def index
        @sensors = Sensor.all
        respond_with @sensors
    end

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
        else
            @sensor = Sensor.new

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
    def edit
        @sensor = Sensor.find(params[:id])
    end
    def update
        @sensor = Sensor.find(params[:id])
        respond_to do |format|
            if @sensor.update_attributes(params[:sensor])
                flash[:notice] = 'Sensor  was successfully updated.'
                format.html { redirect_to :action => "index" }
                format.json { head :no_content }
            else
              format.html { render action: "edit" }
              format.json { render json: @sensor.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @sensor = Sensor.find(params[:id])
        @sensor.delete
        flash[:notice] = "Sensor deleted successfully !"
        redirect_to :action => "index"
    end

end
