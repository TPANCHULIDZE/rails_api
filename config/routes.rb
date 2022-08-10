Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[create show destroy update]
      resources :tokens, only: %i[create]
      resources :products
      resources :orders, only: %i[index show create]
    end
  end
end
