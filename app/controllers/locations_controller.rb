class LocationsController < ApplicationController
    respond_to :json, :html

    def index
        @locations = Location.all
        respond_with @locations
    end

    def new
        @location = Location.new
    end
    def create
        @location = Location.new(params[:sensor])
        if @location.save
            flash[:notice] = "Sensor created successfully !"
            redirect_to :action => "index"
        else
            flash[:error] = "Couldn't create the Sensor. Please try again."
            render "new"
        end
    end
    def edit
        @location = Location.find(params[:id])
    end

    def update
        @location = Location.find(params[:id])
        respond_to do |format|
            if @location.update_attributes(params[:sensor])
                flash[:notice] = 'Sensor  was successfully updated.'
                format.html { redirect_to :action => "index" }
                format.json { head :no_content }
            else
              format.html { render action: "edit" }
              format.json { render json: @location.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @location = Location.find(params[:id])
        @location.delete
        flash[:notice] = "Location deleted successfully !"
        redirect_to :action => "index"
    end

    def show
        redirect_to :action => 'edit'
    end
end