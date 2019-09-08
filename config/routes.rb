Rails.application.routes.draw do
  root 'sires#index'

  resources :sires, except: %i[destroy]

  patch 'bloodline/update'
  get 'bloodline/destroy'

  resources :sire_filters, only: %i[index create]
end
