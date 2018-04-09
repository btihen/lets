json.extract! species_count_date, :date, :elevation_m, :plot_code,
                                  :species_code, :species_count_plot
json.url species_count_date_url( species_count_date, format: :json )
