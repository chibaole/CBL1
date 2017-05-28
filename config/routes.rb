Rails.application.routes.draw do
  namespace :admin do
    resources :code_batches
    resources :products
    resources :promotions
    resources :promotion_codes

    root to: "code_batches#index"
  end

  resources :users do
    collection do
      resource :registrations, only: [:show, :create]
      resource :sessions, only: [:new, :create, :destroy]
      resource :confirmations, only: [:show]
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
