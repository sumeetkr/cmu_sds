class DevicesController < ApplicationController
    respond_to :json, :html

    def index
        @devices = Device.all
        respond_with @devices
    end

    def new
        @device_types = DeviceType.all
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

          # pre-populate sensors for firefly device
          if @device.device_type_id == "Firefly_v2"   # firefly_v2 has an id of 1
            temp_device_guid = @device.guid
            @device.guid = @device.id.to_s << "." << @device.guid << ".device.sv.cmu.edu"

            # iterate through Sensor Types
            #dt = DeviceType.find_by_id(1)
            #default_sensor_config = JSON.parse(dt.default_config)

            # replace with property_type
            ["Temperature",
             "Digital Temperature",
             "Light",
             "Pressure",
             "Humidity",
             "Motion",
             "Audio P2P",
             "Accelerometer x",
             "Accelerometer y",
             "Accelerometer z"
            ].each do |pt|
              # find Sensor type with property pt
              st = SensorType.find_by_property_type(pt)
              # create Sensor with this Sensor Type
              [{
                   :guid => ".sensor.sv.cmu.edu",
                   :sensor_type_id => st.id,
                   :device_guid => @device.guid,
                   :device_id => @device.id
               }].each do |attributes|
                s = Sensor.create(attributes)
                s.guid = s.id.to_s << "." << temp_device_guid << s.guid
                s.save
                # add this Sensor to the Sensor Type
                st.sensors << s
                # add Sensor to the device
                @device.sensors << s
              end
            end
            @device.save
          end

          flash[:notice] = "Device created successfully !"
          redirect_to :action => "index"
        else
          format.html { render action: "new" }
          render "new"
          format.js
        end

    end

    def edit
        @device_types = DeviceType.all
        @device = Device.find(params[:id])
    end
    def update
        @device = Device.find(params[:id])
        respond_to do |format|
            if @device.update_attributes(params[:device])
                @device.guid = @device.id.to_s << "." << @device.guid << ".device.sv.cmu.edu"
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


