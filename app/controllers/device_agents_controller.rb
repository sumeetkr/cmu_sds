class DeviceAgentsController < ApplicationController
    def new
        if (!params[:guid].blank?)   # && !params[:physical_location].nil? && !params[:network_address].nil?)
            @device_agent = DeviceAgent.new(:guid => params[:guid])
            @device_agent.physical_location = params[:physical_location] unless params[:physical_location].blank?
            @device_agent.network_address = params[:network_address] unless params[:network_address].blank?
            @device_agent.save
            #redirect_to device_agents_url
        else
            @device_agent = DeviceAgent.new
                respond_to do |format|
                format.html # new.html.erb
                format.json { render json: @device_agent }
            end
        end
    end

    def create
      @device_agent = DeviceAgent.new(params[:device_agent])
      respond_to do |format|
        if @device_agent.save
          format.html { redirect_to @device_agent, notice: 'Device Agent was successfully created.' }
          # format.json { render json: @device_agent, status: :created, location: @device_agent }
          format.js
        else
          format.html { render action: "new" }
          # format.json { render json: @device_agent.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    def index
        @device_agents = DeviceAgent.all
    end

    def show
    end

    def edit
        @device_agent = DeviceAgent.find(params[:id])
    end

    def update
    end

    def destroy
    end
end
