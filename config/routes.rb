CmuSds::Application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => 'home#index'

  match 'dashboard' => 'home#dashboard', :as => "dashboard"

  #root :to => 'projects#index'
  match '/get_devices' => 'devices#get_devices'
  resources :sensor_readings, :sensors, :devices, :device_agents, :sensor_types, :device_types, :locations
  match ':controller(/:action(/:id))(.:format)'
end
