Rails.application.routes.draw do
  get 'home', to: "static_pages#home"
  get 'static_pages/home'
  devise_for :admins
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tree_measurements
  resources :tree_species
  resources :tree_plots

  root to: "static_pages#home"
end
