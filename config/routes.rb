CmuSds::Application.routes.draw do
  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => 'home#index'

  #root :to => 'projects#index'

  resource :sensor_readings

end
