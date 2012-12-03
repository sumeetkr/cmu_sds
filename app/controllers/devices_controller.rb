class DevicesController < ApplicationController
    respond_to :json, :html

    def index
        @devices = Device.all
        respond_with @devices
    end

    def new
        if (!params[:guid].blank? && !params[:device_type_id].blank?)   # && !params[:physical_location].nil? && !params[:network_address].nil?)
            @device = Device.new(:guid => params[:guid], :device_type_id => params[:device_type_id])
            @device.physical_location = params[:physical_location] unless params[:physical_location].blank?
            @device.network_address = params[:network_address] unless params[:network_address].blank?
            @device.save
            #redirect_to devices_path
        else
            @device = Device.new
            respond_to do |format|
                format.html # new.html.erb
                format.json { render json: @device }
            end
        end
    end

    def create
      @device = Device.new(params[:device])
        if @device.save
          flash[:notice] = "Device created successfully !"
          redirect_to :action => "index"
        else
          format.html { render action: "new" }
          render "new"
          format.js
        end

    end

    def edit
        @device = Device.find(params[:id])
    end
    def update
        @device = Device.find(params[:id])
        respond_to do |format|
            if @device.update_attributes(params[:device])
                flash[:notice] = 'Device  was successfully updated.'
                format.html { redirect_to :action => "index" }
                format.json { head :no_content }
            else
              format.html { render action: "edit" }
              format.json { render json: @device.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @device = Device.find(params[:id])
        @device.delete
        flash[:notice] = "Device deleted successfully !"
        redirect_to :action => "index"
    end

end


