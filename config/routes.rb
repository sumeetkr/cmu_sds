CmuSds::Application.routes.draw do

  #root :to => 'projects#index'

  resource :sensor_readings

end
