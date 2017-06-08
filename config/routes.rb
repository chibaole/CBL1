Rails.application.routes.draw do
  root "promos#code"

  resources :promos, only: [] do
    collection do
      get :code
      post :verify
    end
  end

  resources :promotion_orders, only: [:new, :create, :show, :edit, :update] do
    member do
      get :confirm
      put :do_confirm
      patch :do_confirm
      get :success
    end
  end


  get '/admin', to: 'admin/dashboard#index'

  namespace :admin do
    namespace :delegate do
      resources :products
      resources :promotions
      resources :code_batches do
        member do
          patch :generate_codes
          get :codes
        end
      end
      resources :promotion_codes
      resources :promotion_orders
    end

    resources :dashboard, only: [] do
      collection do
        get :index
      end
    end

    resources :users, only: [] do
      collection do
        resource :sessions, only: [:new, :create, :destroy]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
