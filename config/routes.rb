Rails.application.routes.draw do
  resources :users
  root to: 'pages#home'
  get 'lanzarote', to: 'pages#lanzarote'
  get 'tenerife', to: 'pages#tenerife'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
