CmuSds::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => 'home#index'

  #root :to => 'projects#index'

  match "sensors/index" => "sensors#index"   # by default GET index goes to show

  resource :sensor_readings, :sensors

end
