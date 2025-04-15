Rails.application.routes.draw do
  resources :contacts, only: %i[new create]
  devise_for :users
  resources :users
  root to: 'pages#home'
  post 'contact_us', to: 'pages#contact_us'
  get 'lanzarote', to: 'pages#lanzarote'
  get 'tenerife', to: 'pages#tenerife'
  get 'grancanaria', to: 'pages#grancanaria'
  get 'fuerteventura', to: 'pages#fuerteventura'
  get 'marbella', to: 'pages#marbella'
  get 'review_page', to: 'pages#review_page'
  get 'madrid', to: 'pages#madrid'
  get 'ibiza', to: 'pages#ibiza'
  get 'spain-property-guide', to: 'pages#spain-property-guide'
  get 'free-consultation', to: 'pages#free_consultation'
  get 'consultation', to: 'pages#consultation'
  get 'vv-license', to: 'pages#vv_license'

  
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
