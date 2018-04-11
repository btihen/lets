json.extract! species_avg_by_date, :measurement_date, :pivoted_data
json.url tree_measurement_url(species_avg_by_date, format: :json)
