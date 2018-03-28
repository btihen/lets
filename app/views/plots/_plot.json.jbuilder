json.extract! plot, :id, :plot_name, :plot_code, :elevation_m, :latitude, :longitude, :created_at, :updated_at
json.url plot_url(plot, format: :json)
