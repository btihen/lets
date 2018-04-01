Rails.application.routes.draw do
  get 'home',    to: "static_pages#home"
  get 'design',  to: "static_pages#transect_design"
  get 'collect', to: "static_pages#data_collection"
  get 'analyze', to: "static_pages#data_analysis"
  get 'graph',   to: "static_pages#kite_graphs"
  get 'species', to: "static_pages#species"
  get 'growth',  to: "static_pages#_growth"
  get 'static_pages/home'
  devise_for :admins
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tree_measurements
  resources :tree_species
  resources :tree_plots
  resources :admins
  get 'my_passwd',  to: "admins#my_passwd"
  get 'my_profile', to: "admins#my_profile"

  root to: "static_pages#home"
end
