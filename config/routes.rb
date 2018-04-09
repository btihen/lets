Rails.application.routes.draw do
  get 'home',                to: "educational_pages#home"
  get 'design_study',        to: "educational_pages#design_study"
  get 'collect_data',        to: "educational_pages#collect_data"
  get 'analyze_data',        to: "educational_pages#analyze_data"
  get 'graph_data',          to: "educational_pages#graph_data"
  get 'species_animated',    to: "educational_pages#species_animated"
  get 'species_count_date',  to: "educational_pages#species_count_date"
  get 'species_count_avg_year', to: "educational_pages#species_count_avg_year"
  get 'species_longitudinal',to: "educational_pages#species_longitudinal"
  get 'growth_animated',     to: "educational_pages#growth_animated"
  get 'growth_elevation',    to: "educational_pages#growth_elevation"
  get 'growth_longitudinal', to: "educational_pages#growth_longitudinal"
  get 'educational_pages/home'
  devise_for :admins
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tree_measurements
  resources :tree_species
  resources :tree_plots
  resources :admins
  get 'my_passwd',  to: "admins#my_passwd"
  get 'my_profile', to: "admins#my_profile"

  root to: "educational_pages#home"
end
