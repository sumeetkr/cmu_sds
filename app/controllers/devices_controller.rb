class DevicesController < ApplicationController
    respond_to :json

    def index
        @devices = Device.all
        respond_with @devices
    end

    def show
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
      respond_to do |format|
        if @device.save
          format.html { redirect_to @device, notice: 'Device was successfully created.' }
      #    format.json { render json: @device, status: :created, location: @device }
          format.js
        else
          format.html { render action: "new" }
      #    format.json { render json: @device.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def edit
        @device = Device.find(params[:id])
    end
    def update

    end

    def destroy

    end

end


