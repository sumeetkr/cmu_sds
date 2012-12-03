class SensorTypesController < ApplicationController
    respond_to :json, :html
    def index
        @sensor_types = SensorType.all
        respond_with @sensor_types
    end

    def new
        if (!params[:property_type].blank?)
            @sensor_type = SensorType.new(:property_type => params[:property_type], :metadata_json => params[ :metadata_json])
            @sensor_type.save
            #redirect_to devices_path
        else
            @sensor_type = SensorType.new
                respond_to do |format|
                format.html
                format.json { render json: @sensor_type }
            end
        end
    end
    def create
        @sensor_type = SensorType.new(params[:sensor_type])
        if @sensor_type.save
            flash[:notice] = "Sensor Type created successfully !"
            redirect_to :action => "index"
        else
            flash[:error] = "Couldn't create the Sensor Type. Please try again."
            render "new"
        end
    end

    def edit
        @sensor_type = SensorType.find(params[:id])
    end
    def update
        @sensor_type = SensorType.find(params[:id])
        respond_to do |format|
            if @sensor_type.update_attributes(params[:sensor_type])
                flash[:notice] = 'Sensor Type was successfully updated.'
                format.html { redirect_to :action => "index" }
                format.json { head :no_content }
            else
              format.html { render action: "edit" }
              format.json { render json: @sensor_type.errors, status: :unprocessable_entity }
            end
        end
    end
    def destroy
        @sensor_type = SensorType.find(params[:id])
        @sensor_type.delete
        flash[:notice] = "Sensor Type deleted successfully !"
        redirect_to :action => "index"
    end
end
