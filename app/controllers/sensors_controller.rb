class SensorsController < ApplicationController

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

end