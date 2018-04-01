Rails.application.routes.draw do
  get 'home',                to: "static_pages#home"
  get 'design_study',        to: "static_pages#design_study"
  get 'collect_data',        to: "static_pages#collect_data"
  get 'analyze_data',        to: "static_pages#analyze_data"
  get 'graph_data',          to: "static_pages#graph_data"
  get 'species_animated',    to: "static_pages#species_animated"
  get 'species_elevation',   to: "static_pages#species_elevation"
  get 'species_longitudinal',to: "static_pages#species_longitudinal"
  get 'growth_animated',     to: "static_pages#growth_animated"
  get 'growth_elevation',    to: "static_pages#growth_elevation"
  get 'growth_longitudinal', to: "static_pages#growth_longitudinal"
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
