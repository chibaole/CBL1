Rails.application.routes.draw do
  get '/admin', to: 'admin/dashboard#index'

  resources :promos, only: [] do
    collection do
      get :code
      post :submit_code
      get :info
      post :submit_info
    end

    member do
      get :confirm_info
      put :confirm
      get :success
      get :show
    end
  end

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
