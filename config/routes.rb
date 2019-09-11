Rails.application.routes.draw do
  root 'ranches#show'

  resources :ranches, only: %i[show]

  resources :sires, except: %i[destroy]
  resources :mares, only: %i[index show]

  resources :matings, only: %i[index show]

  patch 'bloodline/update'
  get 'bloodline/destroy'

  resources :sire_filters, only: %i[index create]
end
