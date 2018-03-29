Rails.application.routes.draw do
  devise_for :admins
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tree_measurements
  resources :tree_species
  resources :tree_plots

  root to: "tree_measurements#index"
end
