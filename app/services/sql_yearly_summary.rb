class SqlYearlySummary

  # def initialize
  #
  # end
  #
  # private
  # def get_sql_summary_species_data
  #   # good sql resource:
  #   # http://www.dofactory.com/sql/select-distinct
  #
  #   # https://stackoverflow.com/questions/46411130/rails-activerecord-raw-sql-read-data-without-loading-everything-into-memory-wit?rq=1
  #   # https://stackoverflow.com/questions/22715130/mysql-nested-query-and-group-by
  #   # https://stackoverflow.com/questions/36320861/convert-decimal-number-to-int-sql
  #   # https://stackoverflow.com/questions/42983935/summarize-an-array-of-hashes-with-a-crosstab-also-called-a-pivot-table
  #   # https://stackoverflow.com/questions/17492167/group-query-results-by-month-and-year-in-postgresql
  #
  #   sql_plot_species_count = %{
  #     SELECT tree_plots.plot_code, tree_plots.elevation_m,
  #       tree_measurements.measurement_date,
  #       tree_species.species_code,
  #       SUM(tree_measurements.tree_label) as species_plot_count
  #     FROM tree_plots
  #       INNER JOIN tree_measurements
  #         ON tree_plots.id = tree_measurements.tree_plot_id
  #       INNER JOIN tree_species
  #         ON tree_measurements.tree_specy_id = tree_species.id
  #     GROUP BY tree_plots.plot_code, tree_plots.elevation_m,
  #       tree_measurements.measurement_date, tree_species.species_code
  #     ORDER BY tree_plots.elevation_m, tree_measurements.measurement_date,
  #       tree_species.species_code
  #   }
  #   # species_elevation = ActiveRecord::Base.connection.execute(sql_plot_species_count)
  #   # species_elevation.each{ |s| puts s.inspect }
  #
  #   # average density by measurement date
  #   # (input of first sql into second sum)
  #   # https://stackoverflow.com/questions/22715130/mysql-nested-query-and-group-by
  #   # https://stackoverflow.com/questions/36320861/convert-decimal-number-to-int-sql
  #   # avg_species_plot_meas_date = %{
  #   #   SELECT elevation_m, measurement_date, species_code,
  #   #       CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
  #   #     FROM (
  #   #       SELECT tree_plots.plot_code, tree_plots.elevation_m,
  #   #         tree_measurements.measurement_date,
  #   #         tree_species.species_code,
  #   #         COUNT(tree_measurements.tree_specy_id) as species_plot_count
  #   #       FROM tree_plots
  #   #         INNER JOIN tree_measurements
  #   #           ON tree_plots.id = tree_measurements.tree_plot_id
  #   #         INNER JOIN tree_species
  #   #           ON tree_measurements.tree_specy_id = tree_species.id
  #   #       GROUP BY tree_plots.plot_code, tree_plots.elevation_m,
  #   #         tree_measurements.measurement_date, tree_species.species_code
  #   #       ORDER BY tree_plots.elevation_m, tree_measurements.measurement_date,
  #   #         tree_species.species_code
  #   #     ) as temp
  #   #     GROUP BY temp.elevation_m, temp.measurement_date, temp.species_code
  #   #     ORDER BY temp.elevation_m, temp.measurement_date, temp.species_code;
  #   # }
  #   # avg_species_plot_measurement_date = %{
  #   #   SELECT elevation_m, measurement_date, species_code,
  #   #       CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
  #   #     FROM (
  #   #       #{sql_plot_species_count}
  #   #     ) as temp
  #   #     GROUP BY temp.elevation_m, temp.measurement_date, temp.species_code
  #   #     ORDER BY temp.elevation_m, temp.measurement_date, temp.species_code;
  #   # }
  #   # species_by_elevation = ActiveRecord::Base.connection.execute(avg_species_plot_measurement_date)
  #   # species_elevation.each{ |s| puts s.inspect }
  #
  #   # average by year
  #   avg_species_plot_year = %{
  #     SELECT
  #         CAST(extract(year from measurement_date) AS INTEGER) AS year,
  #         elevation_m, species_code,
  #         CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
  #       FROM (
  #         #{sql_plot_species_count}
  #       ) as temp
  #       GROUP BY extract(year from temp.measurement_date),
  #         temp.elevation_m, temp.species_code
  #       ORDER BY extract(year from temp.measurement_date),
  #         temp.elevation_m, temp.species_code
  #   }
  #   species_by_elevation = ActiveRecord::Base.connection.execute(avg_species_plot_year)
  #   # species_elevation.each{ |s| puts s.inspect }
  #
  #   # CROSSTAB Data - data seems too complex for my SQL
  #   # convert above into desired spreadsheet format (USING CROSSTAB & tablefunc extension)
  #   # http://www.vertabelo.com/blog/technical-articles/creating-pivot-tables-in-postgresql-using-the-crosstab-function
  #   # https://www.compose.com/articles/metrics-maven-creating-pivot-tables-in-postgresql-using-crosstab/
  #   # https://stackoverflow.com/questions/3002499/postgresql-crosstab-query/11751905#11751905
  #   # https://stackoverflow.com/questions/20618323/create-a-pivot-table-with-postgresql
  #   # https://gist.github.com/romansklenar/8086496
  # end
  #
  # def make_pivot_array(species_counts, args=nil)
  #
  #   args ||= {column_name: 'elevation_m',
  #             row_name: 'species_code',
  #             field_name: 'avg_species_count'}
  #
  #   # DataRow = Struct.new(:elevation_m, :species_code, :avg_species_count)
  #   DataRow = Struct.new( args[:column_name].to_sym,  # :elevation_m
  #                         args[:row_name].to_sym,     # :species_code
  #                         args[:field_name].to_sym)   # :avg_species_count
  #
  #   pivot_vals = []
  #   # make data into a format usable by PivotTable
  #   species_count.each do |hash|
  #     pivot_vals << DataRow.new(hash[args[:column_name]], # hash['elevation_m']
  #                               hash[args[:row_name]],    # hash['species_code']
  #                               hash[args[:field_name]] ) # hash['avg_species_count']
  #   end
  #   # pp pivot_vals
  #   # configure pivot table
  #   pivot = PivotTable::Grid.new do |g|
  #     g.source_data = pivot_vals
  #     g.column_name = args[:column_name].to_sym,  # :elevation_m
  #     g.row_name    = args[:row_name].to_sym,     # :species_code
  #     g.field_name  = args[:field_name].to_sym)   # :avg_species_count
  #   end
  #   # build the data_grid
  #   pivot.build
  #   # return array of data ready to print
  #   pivot_array = pivot.data_grid.dup
  #   pivot_array.each_with_index do |row, index|
  #     # convert data nils into 0
  #     pivot_array[index] = pivot_array[index].map{|r| r||0 }
  #     # add the elevation to the array
  #     pivot_array[index].unshift( pivot.row_headers[index] )
  #     # pivot_array[index] = [pivot.row_headers[index]] + pivot_array[index]
  #   end
  #   # add headers to the top of the array
  #   # pivot_array.unshift( ["elevation_m"] + pivot.row_headers )
  #   pivot_array.unshift( [args[:column_name]] + pivot.row_headers )
  # end


end
