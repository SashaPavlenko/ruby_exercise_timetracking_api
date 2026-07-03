Rails.application.routes.draw do
  resources :time_entries, only: [ :create ]
  resources :projects, only: [ :show ]
end
