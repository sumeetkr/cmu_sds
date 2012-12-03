class DeviceTypesController < ApplicationController

    def index
        @device_types = DeviceType.all
        respond_to do |format|
            format.html
            format.json { render json: @device_types }
        end
    end

    def new
        if (!params[:device_type].blank? && !params[:version].blank? && !params[:manufacturer].blank?)
            @device_type = DeviceType.new(:device_type => params[:device_type], :version => params[:version], :manufacturer => params[:manufacturer])
            @device_type.save
            #redirect_to devices_path
        else
            @device_type = DeviceType.new
                respond_to do |format|
                format.html
                format.json { render json: @device_type }
            end
        end
    end
    def create
        @device_type = DeviceType.new(params[:device_type])
        if @device_type.save
            flash[:notice] = "Device Type created successfully !"
            redirect_to :action => "index"
        else
            flash[:error] = "Couldn't create the Device Type. Please try again."
            render "new"
        end
    end

    def edit
        @device_type = DeviceType.find(params[:id])
    end
    def update
        @device_type = DeviceType.find(params[:id])
        respond_to do |format|
            if @device_type.update_attributes(params[:device_type])
                flash[:notice] = 'Device Type was successfully updated.'
                format.html { redirect_to :action => "index" }
                format.json { head :no_content }
            else
              format.html { render action: "edit" }
              format.json { render json: @device_type.errors, status: :unprocessable_entity }
            end
        end

    end
    def destroy
        @device_type = DeviceType.find(params[:id])
        @device_type.delete
        flash[:notice] = "Device Type deleted successfully !"
        redirect_to :action => "index"
    end

end
