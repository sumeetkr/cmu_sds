CmuSds::Application.routes.draw do

  #root :to => 'projects#index'

  match "sensors/index" => "sensors#index"   # by default GET index goes to show

  resource :sensor_readings, :sensors

end
