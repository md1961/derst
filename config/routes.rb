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

  resource :mating_list, only: %i[show update destroy] do
    get :delete
    get :prev, :next
  end

  resources :ranch_mares, only: %i[new create destroy]

  resources :racers, only: %i[show new create update] do
    member do
      post :create_result, :weekly, :create_mare
      patch :graze, :ungraze, :retire
    end
  end

  resources :races, only: %i[index] do
    collection do
      get :weights
    end
  end

  resources :results, only: %i[edit update destroy]

  resources :target_races, only: %i[create destroy]

  resources :post_races, only: %i[index create edit update destroy]

  patch 'bloodline/update'
  get 'bloodline/destroy'

  resources :sire_filters, only: %i[index create]
end
