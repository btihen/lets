json.extract! tree, :id, :plot_name, :plot_latitude, :plot_longitude, :species, :circumfrence_cm, :measurement_date, :created_at, :updated_at
json.url tree_url(tree, format: :json)
