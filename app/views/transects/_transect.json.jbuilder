json.extract! transect, :id, :transect_name, :transect_code, :target_slope, :target_aspect, :created_at, :updated_at
json.url transect_url(transect, format: :json)
