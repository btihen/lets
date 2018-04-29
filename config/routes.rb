Rails.application.routes.draw do
  get 'educational_pages/home'
  get 'home',                 to: "educational_pages#home"
  get 'design_study',         to: "educational_pages#design_study"
  get 'collect_data',         to: "educational_pages#collect_data"
  get 'analyze_data',         to: "educational_pages#analyze_data"
  get 'graph_data',           to: "educational_pages#graph_data"
  get 'species_animated',     to: "educational_pages#species_animated"
  get 'species_count_date',   to: "educational_pages#species_count_date"
  get 'species_avg_by_date',  to: "educational_pages#species_avg_by_date"
  get 'species_avg_by_year',  to: "educational_pages#species_avg_by_year"
  get 'species_avg_by_decade', to: "educational_pages#species_avg_by_decade"
  get 'species_longitudinal', to: "educational_pages#species_longitudinal"
  get 'growth_animated',      to: "educational_pages#growth_animated"
  get 'growth_elevation',     to: "educational_pages#growth_elevation"
  get 'growth_longitudinal',  to: "educational_pages#growth_longitudinal"
  get 'my_passwd',            to: "admins#my_passwd"
  get 'my_profile',           to: "admins#my_profile"
  # allo csv uploads
  post 'tree_measurements/import_csv', to: "tree_measurements#import_csv"
  post 'tree_species/import_csv', to: "tree_species#import_csv"
  post 'tree_plots/import_csv',   to: "tree_plots#import_csv"
  post 'transects/import_csv',    to: "transects#import_csv"
  devise_for :admins
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :transect_admin_editors
  resources :tree_measurements
  resources :tree_species
  resources :tree_plots
  resources :transects
  resources :admins

  root to: "educational_pages#home"

  comfy_route :cms_admin, path: "/admin"
  # Ensure that this route is defined last
  comfy_route :cms, path: "/analyze"
end
