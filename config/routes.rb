Rails.application.routes.draw do
  devise_for :users
  resources :users
  root to: 'pages#home'
  get 'lanzarote', to: 'pages#lanzarote'
  get 'tenerife', to: 'pages#tenerife'
  get 'review_page', to: 'pages#review_page'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
