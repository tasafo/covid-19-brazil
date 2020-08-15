Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :states do
    get '/cities/', to: 'cities#index'
    get '/cities/:slug', to: 'cities#show'
  end
end
