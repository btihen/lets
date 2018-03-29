Rails.application.routes.draw do
  resources :tree_measurements
  resources :tree_species
  resources :tree_plots
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
