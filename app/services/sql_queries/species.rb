module SqlQueries

  class Species

    def initialize(data_request)
      @sql_query = choose_sql_query(data_request)
    end

    def run
      perform
    end

    def self.call(request)
      new(request).send(:perform)
    end

    protected

      attr_reader :sql_query

      def perform
        ActiveRecord::Base.connection.execute(sql_query)
      end

    private

    def choose_sql_query(data_request)
      case data_request
      when :plot_count_by_date
        sql_query = species_per_plot_count_per_date
      when :date_avg_by_elevation
        sql_query = avg_species_per_elevation_by_date
      when :yearly_avg_by_elevation
        sql_query = avg_species_per_elevation_by_year
      when :decade_avg_by_elevation
        sql_query = avg_species_per_elevation_by_decade
      when :decade_avg_all
        sql_query = avg_species_per_elevation_all
      else
        raise NotImplementedError
      end
      sql_query
    end

    def species_per_plot_count_per_date
      %{
        SELECT
          tree_measurements.measurement_date,
          tree_plots.elevation_m, tree_plots.plot_code,
          tree_species.species_code,
          COUNT(tree_measurements.tree_specy_id) as species_plot_count
        FROM tree_plots
          INNER JOIN tree_measurements
            ON tree_plots.id = tree_measurements.tree_plot_id
          INNER JOIN tree_species
            ON tree_measurements.tree_specy_id = tree_species.id
        GROUP BY tree_plots.plot_code, tree_plots.elevation_m,
          tree_measurements.measurement_date, tree_species.species_code
        ORDER BY extract(year from tree_measurements.measurement_date) DESC,
          tree_measurements.measurement_date DESC,
          tree_plots.elevation_m, tree_plots.plot_code, tree_species.species_code
      }
    end

    def avg_species_per_elevation_by_date
      %{
        SELECT
            measurement_date,
            elevation_m, species_code,
            CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
          FROM (
            #{species_per_plot_count_per_date}
          ) as temp
          GROUP BY temp.measurement_date,
            temp.elevation_m, temp.species_code
          ORDER BY temp.measurement_date DESC,
            temp.elevation_m, temp.species_code;
      }
    end

    def avg_species_per_elevation_by_year
      %{
        SELECT
            CAST(extract(year from measurement_date) AS INTEGER) AS year,
            elevation_m, species_code,
            CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
          FROM (
            #{species_per_plot_count_per_date}
          ) as temp
          GROUP BY extract(year from temp.measurement_date),
            temp.elevation_m, temp.species_code
          ORDER BY extract(year from temp.measurement_date) DESC,
            temp.elevation_m, temp.species_code
      }
    end

    def avg_species_per_elevation_by_decade
      # https://www.postgresql.org/message-id/162867790707271230u4258b9a9re0b672e948e44684%40mail.gmail.com
      # https://dba.stackexchange.com/questions/86274/group-by-range-of-years?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
      # %{
      #   SELECT
      #       filter (where year between 2015 and 2019) as range2010_2014,
      #       filter (where year between 2020 and 2024) as range2010_2014,
      #       filter (where year between 2025 and 2029) as range2010_2014,
      #       elevation_m, species_code,
      #       CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
      #     FROM (
      #       #{species_per_plot_count_per_date}
      #     ) as temp
      #     GROUP BY
      #       temp.elevation_m, temp.species_code
      #     ORDER BY
      #       temp.elevation_m, temp.species_code
      # }
      %{
        SELECT
            elevation_m, species_code,
            CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
          FROM (
            #{species_per_plot_count_per_date}
          ) as temp
          GROUP BY
            temp.elevation_m, temp.species_code
          ORDER BY
            temp.elevation_m, temp.species_code
      }
      # %{
      #   SELECT
      #       CAST(extract(year from measurement_date) AS INTEGER) AS year,
      #       elevation_m, species_code,
      #       CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
      #     FROM (
      #       #{species_per_plot_count_per_date}
      #     ) as temp
      #     GROUP BY extract(year from temp.measurement_date),
      #       temp.elevation_m, temp.species_code
      #     ORDER BY extract(year from temp.measurement_date) DESC,
      #       temp.elevation_m, temp.species_code
      # }
    end

    def avg_species_per_elevation_all
      %{
        SELECT
            elevation_m, species_code,
            CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
          FROM (
            #{species_per_plot_count_per_date}
          ) as temp
          GROUP BY
            temp.elevation_m, temp.species_code
          ORDER BY
            temp.elevation_m, temp.species_code
      }
    end


    # sql resources:
    # http://www.dofactory.com/sql/select-distinct
    # https://stackoverflow.com/questions/46411130/rails-activerecord-raw-sql-read-data-without-loading-everything-into-memory-wit?rq=1
    # https://stackoverflow.com/questions/22715130/mysql-nested-query-and-group-by
    # https://stackoverflow.com/questions/36320861/convert-decimal-number-to-int-sql
    # https://stackoverflow.com/questions/42983935/summarize-an-array-of-hashes-with-a-crosstab-also-called-a-pivot-table
    # https://stackoverflow.com/questions/17492167/group-query-results-by-month-and-year-in-postgresql

    # average grouped by elevation & time frame
    # (input of first sql into second sum)
    # https://stackoverflow.com/questions/22715130/mysql-nested-query-and-group-by
    # https://stackoverflow.com/questions/36320861/convert-decimal-number-to-int-sql

    # def crosstab
    #   # CROSSTAB Data - seems too complex for my SQL
    #   # convert above into desired spreadsheet format (USING CROSSTAB & tablefunc extension)
    #   # http://www.vertabelo.com/blog/technical-articles/creating-pivot-tables-in-postgresql-using-the-crosstab-function
    #   # https://www.compose.com/articles/metrics-maven-creating-pivot-tables-in-postgresql-using-crosstab/
    #   # https://stackoverflow.com/questions/3002499/postgresql-crosstab-query/11751905#11751905
    #   # https://stackoverflow.com/questions/20618323/create-a-pivot-table-with-postgresql
    #   # https://gist.github.com/romansklenar/8086496
    # end

  end

end
