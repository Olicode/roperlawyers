Rails.application.routes.draw do
  resources :contacts, only: %i[new create]
  post 'contact_notification', to: 'contacts#contact_notification'
  get 'test_email', to: 'contacts#test_email'
  devise_for :users
  resources :users
  root to: 'pages#home'
  post 'contact_us', to: 'pages#contact_us'
  get 'lanzarote', to: 'pages#lanzarote'
  get 'lanzarote-conveyancing-lawyer', to: 'pages#lanzarote_conveyancing_lawyer'
  get 'puerto-del-carmen-property-conveyancing-lawyer', to: 'pages#puerto_del_carmen_property_conveyancing_lawyer'
  get 'tenerife', to: 'pages#tenerife'
  get 'grancanaria', to: 'pages#grancanaria'
  get 'fuerteventura', to: 'pages#fuerteventura'
  get 'marbella', to: 'pages#marbella'
  #get 'review_page', to: 'pages#review_page'
  get 'madrid', to: 'pages#madrid'
  get 'ibiza', to: 'pages#ibiza'
  get 'spain-property-guide', to: 'pages#spain-property-guide'
  get 'free-consultation', to: 'pages#free_consultation'
  get 'consultation', to: 'pages#consultation'
  get 'reviews', to: 'pages#reviews'
  get 'our-story', to: 'pages#our_story'
  get 'team', to: 'pages#team'
  get 'team/olivier-roper', to: 'pages#team_olivier_roper'
  get 'team/rachel-jane-buckett', to: 'pages#team_rachel_jane_buckett'
  get 'why-choose-us', to: 'pages#why_choose_us'
  
  get 'services', to: 'pages#services'
  get 'property-buying-guide', to: 'pages#property_buying_guide'
  get 'canary-islands-holiday-rental-laws', to: 'pages#canary_islands_holiday_rental_laws'
  get 'holiday-rental-rules-2025', to: redirect('/canary-islands-holiday-rental-laws', status: 301)
  get 'vv-license', to: 'pages#vv_license'
  get 'blog', to: 'pages#blog'
  get 'privacy-policy', to: 'pages#privacy_policy'
  get 'cookies-policy', to: 'pages#cookies_policy'
  get 'buying-property', to: 'pages#buying_property'
  get 'buying-property/lanzarote', to: 'pages#buying_property_lanzarote'
  get 'buying-property/lanzarote/puerto-del-carmen', to: 'pages#buying_property_lanzarote_puerto_del_carmen'
  get 'buying-property/lanzarote/playa-blanca', to: 'pages#buying_property_lanzarote_playa_blanca'
  get 'buying-property/lanzarote/costa-teguise', to: 'pages#buying_property_lanzarote_costa_teguise'
  
  get 'selling-property', to: 'pages#selling_property'
  get 'selling-property/lanzarote', to: 'pages#selling_property_lanzarote'
  get 'selling-property/lanzarote/puerto-del-carmen', to: 'pages#selling_property_lanzarote_puerto_del_carmen'
  get 'selling-property/lanzarote/playa-blanca', to: 'pages#selling_property_lanzarote_playa_blanca'
  get 'selling-property/lanzarote/costa-teguise', to: 'pages#selling_property_lanzarote_costa_teguise'
  
  get 'wills', to: 'pages#wills'
  get 'wills/lanzarote', to: 'pages#wills_lanzarote'
  get 'wills/lanzarote/puerto-del-carmen', to: 'pages#wills_lanzarote_puerto_del_carmen'
  get 'wills/lanzarote/playa-blanca', to: 'pages#wills_lanzarote_playa_blanca'
  get 'wills/lanzarote/costa-teguise', to: 'pages#wills_lanzarote_costa_teguise'
  
  get 'inheritance', to: 'pages#inheritance'
  get 'inheritance/lanzarote', to: 'pages#inheritance_lanzarote'
  get 'inheritance/lanzarote/puerto-del-carmen', to: 'pages#inheritance_lanzarote_puerto_del_carmen'
  get 'inheritance/lanzarote/playa-blanca', to: 'pages#inheritance_lanzarote_playa_blanca'
  get 'inheritance/lanzarote/costa-teguise', to: 'pages#inheritance_lanzarote_costa_teguise'
  
  get 'new-build-registration', to: 'pages#new_build_registration'
  get 'new-build-registration/lanzarote', to: 'pages#new_build_registration_lanzarote'
  get 'new-build-registration/lanzarote/puerto-del-carmen', to: 'pages#new_build_registration_lanzarote_puerto_del_carmen'
  get 'new-build-registration/lanzarote/playa-blanca', to: 'pages#new_build_registration_lanzarote_playa_blanca'
  get 'new-build-registration/lanzarote/costa-teguise', to: 'pages#new_build_registration_lanzarote_costa_teguise'
  
  get 'holiday-rental-license', to: 'pages#holiday_rental_license'
  get 'holiday-rental-license/lanzarote', to: 'pages#holiday_rental_license_lanzarote'
  get 'holiday-rental-license/lanzarote/puerto-del-carmen', to: 'pages#holiday_rental_license_lanzarote_puerto_del_carmen'
  get 'holiday-rental-license/lanzarote/playa-blanca', to: 'pages#holiday_rental_license_lanzarote_playa_blanca'
  get 'holiday-rental-license/lanzarote/costa-teguise', to: 'pages#holiday_rental_license_lanzarote_costa_teguise'
  get 'thank-you', to: 'pages#thank_you'
  get 'propertybase-success', to: 'pages#propertybase_success'
  get 'step2-contact', to: 'pages#step2_contact'
  get 'contact', to: 'pages#contact'
  
  # Webhooks
  post 'webhooks/propertybase', to: 'webhooks#propertybase'
  
  # SEO Sitemap
  get 'sitemap.xml', to: 'sitemaps#index', defaults: { format: 'xml' }
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
