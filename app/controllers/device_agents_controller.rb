class DeviceAgentsController < ApplicationController
    respond_to :json, :html

    def index
        @device_agents = DeviceAgent.all
        respond_with @device_agents
    end

    def new
        if (!params[:guid].blank?)
            @device_agent = DeviceAgent.new(:guid => params[:guid])
            @device_agent.physical_location = params[:physical_location] unless params[:physical_location].blank?
            @device_agent.network_address = params[:network_address] unless params[:network_address].blank?
            @device_agent.save
        else
            @device_agent = DeviceAgent.new
            respond_with @device_agent
        end
    end

    def create
      @device_agent = DeviceAgent.new(params[:device_agent])
        if @device_agent.save
          flash[:notice] = "Device Agent created successfully !"
          redirect_to :action => "index"
        else
          flash[:error] = "Couldn't create the Device agent. Please try again."
          render "new"
        end
    end
    def edit
        @device_agent = DeviceAgent.find(params[:id])
        @devices = @device_agent.devices
    end
    def update
        @device_agent = DeviceAgent.find(params[:id])
        respond_to do |format|
            if @device_agent.update_attributes(params[:device_agent])
                flash[:notice] = 'Device Agent  was successfully updated.'
                format.html { redirect_to :action => "index" }
                format.json { head :no_content }
            else
              format.html { render action: "edit" }
              format.json { render json: @device_agent.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @device_agent = DeviceAgent.find(params[:id])
        @device_agent.delete
        flash[:notice] = "Device Agent deleted successfully !"
        redirect_to :action => "index"
    end
end
