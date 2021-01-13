Rails.application.routes.draw do
  root 'ranches#show'

  resources :ranches, only: %i[show] do
    member do
      patch :next_week
      get :toggle_mares
    end

    collection do
      get :mare_sort_key
    end
  end

  resources :sires, except: %i[destroy]

  resources :mares, only: %i[index show] do
    collection do
      get :potentials
    end
  end

  resource :mare_list, only: %i[show update destroy] do
    get :delete
  end

  resources :matings, only: %i[index show new create] do
    member do
      post :create_mare
    end

    collection do
      get :recache, :update_racer_name_candidates
    end
  end

  resource :mating_list, only: %i[show update destroy] do
    get :delete
    get :prev, :next
  end

  resources :ranch_mares, only: %i[show new create update destroy] do
    member do
      patch :delete_sire, :update_remark
    end
  end

  resources :ranch_sires, only: %i[index show create destroy]

  resources :racers, only: %i[show new create edit update] do
    collection do
      get :by_mother
    end

    member do
      post :create_result, :create_mare
      post :condition, :weight
      post :weight_fat, :weight_lean, :weight_best, :increment_weight_fat
      patch :graze, :ungraze, :spa, :trip, :injure, :retire
    end
  end

  resources :races, only: %i[index] do
    collection do
      get :weights
    end
  end

  resources :results, only: %i[index edit update destroy] do
    collection do
      get :multiple_entries
    end
  end

  resources :target_races, only: %i[create destroy]

  resources :post_races, only: %i[index create edit update destroy]

  resources :handicap_loads, only: %i[create update destroy]

  patch 'bloodline/update'
  get 'bloodline/destroy'

  resources :sire_filters, only: %i[index create]

  resources :racer_name_samples, except: %i[show new edit] do
    member do
      get :update_enum_item
    end
  end

  get 'stats', to: 'stats#show'

  get 'earnings', to: 'earnings#index'
end
