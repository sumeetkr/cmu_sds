CmuSds::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => 'home#index'

  #root :to => 'projects#index'


  resources :sensor_readings, :sensors, :devices, :device_agents

  #match "sensors/index" => "sensors#index"   # by default GET index goes to show
  match ':controller(/:action(/:id))(.:format)'

end
