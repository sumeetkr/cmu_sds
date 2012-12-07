class DevicesController < ApplicationController
    respond_to :json, :html

    def index
        @devices = Device.all
        respond_with @devices
    end

    def get_devices
        @devices = Device.all
        device_hash = @devices.collect { |d|
          loc = {}
          if d.location.nil?
            loc = {:lat => '', :lon => '', :alt => ''}
          else
            loc[:lat] = d.location.lat.nil? ? nil : d.location.lat
            loc[:lon] = d.location.lon.nil? ? nil : d.location.lon
            loc[:alt] = d.location.alt.nil? ? nil : d.location.alt
          end
          Hash[
            :guid => d.guid,
            :uri => d.uri,
            :print_name => d.print_name,
            :location => loc,
            :sensors => d.sensors.collect{|s| Hash[s.guid => s.sensor_type.property_type]}
          ]
        }
        respond_with device_hash
    end

    def new
        @location = Location.new
        @device_types = DeviceType.all
        if (!params[:guid].blank? && !params[:device_type_id].blank?)   # && !params[:physical_location].nil? && !params[:network_address].nil?)
            @device = Device.new(:guid => params[:guid], :device_type_id => params[:device_type_id])
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
          if @device.device_type_id == "1"   # firefly_v2 has an id of 1
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
        @device = Device.find(params[:id])
        @location = Location.new
        unless @device.location.nil?
          @location = @device.location
        end
        @device_types = DeviceType.all
        @sensors = @device.sensors
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

    def show
        redirect_to :action => "edit"
    end

end


