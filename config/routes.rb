Rails.application.routes.draw do
  root 'sires#index'

  resources :sires, only: %i[index show]

  patch 'bloodline/update'
end
