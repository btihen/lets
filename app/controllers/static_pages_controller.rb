class StaticPagesController < ApplicationController

  before_action :authenticate_admin!, only: []
    # except: [:home, :analysis_intro, :kite_graphing, :species_density, :yearly_growth]

  # project home
  def home
  end

  # Transect Data Collection
  def collect_data
  end

  # Transect Data Analysis
  def analyze_data
  end

  # explain how to make Kite Graphs
  def graph_data
  end

  def species_elevation

    # good sql resource:
    # http://www.dofactory.com/sql/select-distinct

    @altitudes = TreePlot.distinct.pluck(:elevation_m).sort
    @species = TreeSpecy.distinct.pluck(:species_code).sort
    @dates = TreeMeasurement.distinct.pluck(:measurement_date).sort
    # https://blog.bigbinary.com/2016/03/24/support-for-left-outer-joins-in-rails-5.html
    # Author.left_outer_joins(:posts)
    #             .uniq
    #             .select("authors.*, COUNT(posts.*) as posts_count")
    #             .group("authors.id")
    # data = TreeMeasurement.all.join(:tree_plot).join(:tree_specy)
    #           .select("tree_plots.plot_code, tree_plots.elevation_m,
    #             tree_measurements.measurement_date, tree_species.species_code,
    #             COUNT(tree_measurements.tree_specy_id) as species_plot_count")
    #           .group("tree_plots.plot_code, tree_plots.elevation_m,
    #             tree_measurements.measurement_date, tree_species.species_code")
    #           .order("tree_plots.elevation_m, tree_measurements.measurement_date,
    #             tree_species.species_code")

    # this works
    # sums tree count per plot by measurement date
    sql = %{
      SELECT tree_plots.plot_code, tree_plots.elevation_m,
        tree_measurements.measurement_date,
        tree_species.species_code,
        COUNT(tree_measurements.tree_specy_id) as species_plot_count
      FROM tree_plots
        INNER JOIN tree_measurements
          ON tree_plots.id = tree_measurements.tree_plot_id
        INNER JOIN tree_species
          ON tree_measurements.tree_specy_id = tree_species.id
      GROUP BY tree_plots.plot_code, tree_plots.elevation_m,
        tree_measurements.measurement_date, tree_species.species_code
      ORDER BY tree_plots.elevation_m, tree_measurements.measurement_date,
        tree_species.species_code;
    }

    # https://stackoverflow.com/questions/22715130/mysql-nested-query-and-group-by
    # https://stackoverflow.com/questions/36320861/convert-decimal-number-to-int-sql
    # average density by date (input of first sql into second sum)
    sql2 = %{
      SELECT elevation_m, measurement_date, species_code,
          CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
        FROM (
          SELECT tree_plots.plot_code, tree_plots.elevation_m,
            tree_measurements.measurement_date,
            tree_species.species_code,
            COUNT(tree_measurements.tree_specy_id) as species_plot_count
          FROM tree_plots
            INNER JOIN tree_measurements
              ON tree_plots.id = tree_measurements.tree_plot_id
            INNER JOIN tree_species
              ON tree_measurements.tree_specy_id = tree_species.id
          GROUP BY tree_plots.plot_code, tree_plots.elevation_m,
            tree_measurements.measurement_date, tree_species.species_code
          ORDER BY tree_plots.elevation_m, tree_measurements.measurement_date,
            tree_species.species_code
        ) as temp
        GROUP BY temp.elevation_m, temp.measurement_date, temp.species_code
        ORDER BY temp.elevation_m, temp.measurement_date, temp.species_code;
    }

    # average by year
    # https://stackoverflow.com/questions/17492167/group-query-results-by-month-and-year-in-postgresql
    sql3 = %{
      SELECT elevation_m, extract(year from measurement_date) AS year, species_code,
          CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
        FROM (
          SELECT tree_plots.plot_code, tree_plots.elevation_m,
            tree_measurements.measurement_date,
            tree_species.species_code,
            COUNT(tree_measurements.tree_specy_id) as species_plot_count
          FROM tree_plots
            INNER JOIN tree_measurements
              ON tree_plots.id = tree_measurements.tree_plot_id
            INNER JOIN tree_species
              ON tree_measurements.tree_specy_id = tree_species.id
          GROUP BY tree_plots.plot_code, tree_plots.elevation_m,
            tree_measurements.measurement_date, tree_species.species_code
          ORDER BY tree_plots.elevation_m, tree_measurements.measurement_date,
            tree_species.species_code
        ) as temp
        GROUP BY temp.elevation_m, extract(year from temp.measurement_date),
          temp.species_code
        ORDER BY temp.elevation_m, extract(year from temp.measurement_date),
          temp.species_code;
    }


    # convert above into desired spreadsheet format (USING CROSSTAB & tablefunc extension)
    # http://www.vertabelo.com/blog/technical-articles/creating-pivot-tables-in-postgresql-using-the-crosstab-function
    # https://www.compose.com/articles/metrics-maven-creating-pivot-tables-in-postgresql-using-crosstab/
    # https://stackoverflow.com/questions/3002499/postgresql-crosstab-query/11751905#11751905
    # https://stackoverflow.com/questions/20618323/create-a-pivot-table-with-postgresql
    # https://gist.github.com/romansklenar/8086496
    sql4 = %{
      SELECT elevation_m, extract(year from measurement_date) AS year, species_code,
          CAST(AVG(species_plot_count) AS INTEGER) AS avg_species_count
        FROM (
          SELECT tree_plots.plot_code, tree_plots.elevation_m,
            tree_measurements.measurement_date,
            tree_species.species_code,
            COUNT(tree_measurements.tree_specy_id) as species_plot_count
          FROM tree_plots
            INNER JOIN tree_measurements
              ON tree_plots.id = tree_measurements.tree_plot_id
            INNER JOIN tree_species
              ON tree_measurements.tree_specy_id = tree_species.id
          GROUP BY tree_plots.plot_code, tree_plots.elevation_m,
            tree_measurements.measurement_date, tree_species.species_code
          ORDER BY tree_plots.elevation_m, tree_measurements.measurement_date,
            tree_species.species_code
        ) as temp
        GROUP BY temp.elevation_m, extract(year from temp.measurement_date),
          temp.species_code
        ORDER BY temp.elevation_m, extract(year from temp.measurement_date),
          temp.species_code;
    }


    @species_elevation = ActiveRecord::Base.connection.execute(sql)
    # @species_elevation.each{ |s| puts s.inspect }
    # using raw sql queries
    # https://stackoverflow.com/questions/46411130/rails-activerecord-raw-sql-read-data-without-loading-everything-into-memory-wit?rq=1
    # species_elevation.each{ |s| puts s.inspect }
    #<PG::Result:0x00007fd917d98c60 status=PGRES_TUPLES_OK ntuples=283 nfields=5 cmd_tuples=283>
    # {"plot_code"=>"ttfp", "elevation_m"=>0, "measurement_date"=>"2015-10-01", "species_code"=>"ns", "species_plot_count"=>6}
    # {"plot_code"=>"ttfp", "elevation_m"=>0, "measurement_date"=>"2015-10-01", "species_code"=>"spruce bush", "species_plot_count"=>1}
    # {"plot_code"=>"ttfp", "elevation_m"=>0, "measurement_date"=>"2015-10-01", "species_code"=>"st", "species_plot_count"=>1}
    # {"plot_code"=>"lafp", "elevation_m"=>542, "measurement_date"=>"2017-10-10", "species_code"=>"eb", "species_plot_count"=>13}
    # {"plot_code"=>"lafp", "elevation_m"=>542, "measurement_date"=>"2017-10-10", "species_code"=>"ey", "species_plot_count"=>8}
    # {"plot_code"=>"lafp", "elevation_m"=>542, "measurement_date"=>"2017-10-10", "species_code"=>"sf", "species_plot_count"=>8}
    # {"plot_code"=>"lafp", "elevation_m"=>542, "measurement_date"=>"2017-10-10", "species_code"=>"uc", "species_plot_count"=>4}
    # {"plot_code"=>"pdfp", "elevation_m"=>667, "measurement_date"=>"2015-05-01", "species_code"=>"broad-leaved lime", "species_plot_count"=>1}
    # {"plot_code"=>"pdfp", "elevation_m"=>667, "measurement_date"=>"2015-05-01", "species_code"=>"ea", "species_plot_count"=>3}
    # allow limited species (5 species - random?) - 45 too many to graph
    # 5 dates -- aggregate by year (done 2x per year)
    # 16 altitudes -- not evenly spaced - harder to graph
    # [0, 542, 667, 933, 1000, 1116, 1205, 1213, 1270, 1277, 1362, 1419, 1478, 1703, 1844, 1902]
    # transform to:
    # date
    # [elevation_m, species1, species2]
    # [each elevation, species1_avg_count_per_elevation, species2_avg_count_per_elevation]
    # ~2000 measurements -> 300 records
  end

  def species_longitudinal
    # get every unique altitude
    altitudes = TreePlot.distinct.pluck(:elevation_m).sort
    # get each uniqe species
    species = TreeSpecy.distinct
    # get every unique year
    # sum the number of species at each altitude each year - for a given species
    # return table:
    # Elevation | Year 1 | Year 2
    #     0     |    0   |    5
    #    500    |    2   |    3
    #   1000    |    4   |    0
    # ideally group by species!
  end

  def species_animated
  end

  def growth_elevation
  end

  def growth_longitudinal
  end

  def growth_animated
  end

end
