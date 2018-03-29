json.extract! tree_plot, :id, :plot_name, :plot_code, :elevation_m, :latitude, :longitude, :created_at, :updated_at
json.url tree_plot_url(tree_plot, format: :json)
