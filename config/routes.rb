Rails.application.routes.draw do
  root 'ranches#show'

  resources :ranches, only: %i[show] do
    member do
      patch :next_week
    end
  end

  resources :sires, except: %i[destroy]
  resources :mares, only: %i[index show]

  resources :matings, only: %i[index show new create]

  resources :racers, only: %i[show new create update] do
    member do
      post :create_result
    end
  end

  resources :races, only: %i[index]

  resources :results, only: %i[update destroy]

  patch 'bloodline/update'
  get 'bloodline/destroy'

  resources :sire_filters, only: %i[index create]
end
