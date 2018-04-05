class StaticPagesController < ApplicationController

  before_action :authenticate_admin!, only: []
    # except: [:home, :analysis_intro, :kite_graphing, :species_density, :yearly_growth]

  DataRow = Struct.new(:elevation, :species, :count)

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

  def species_count_date
    @species = SqlQueries::Species.new( :plot_count_by_date ).run
    # @species = summary_species_by_date
    respond_to do |format|
      format.html
      # format.json
      format.csv {send_data Convert::SqlToCsv.new(@species).run,
                    filename: "lets_species_count_by_date-#{Date.today}.csv"}
      # format.csv { send_data Convert::SqlToCsv.(@species),
      #                 filename: "lets_species_count-#{Date.today}.csv" }
    end
  end

  def species_count_avg_year
    # get the sql species counted by plot and averaged by year
    # species_elevation = summary_species_by_year
    species_by_elevation = SqlQueries::Species.(:yearly_avg_by_elevation )
    # sort sql by year
    species_grouped_by_year = species_by_elevation.group_by{ |r| r['year'] }

    # convert each year of data to a pivot table
    species_pivot_by_year = {}
    species_grouped_by_year.each do |year, data|
      # species_pivot_by_year[year] = make_pivot_array(data)
      species_pivot_by_year[year] = Convert::SqlToPivotArray.new(data, :tree_species).run
    end

    @species = species_pivot_by_year
    respond_to do |format|
      format.html
      # format.json
      # long list not pivot table (user probably wants pivot table)
      # format.csv { send_data Convert::SqlToCsv.(species_pivot_by_year),
      #               filename: "lets_species_count-#{Date.today}.csv" }

      # species averaged by year in pivot table format
      format.csv {send_data Convert::ArrayToCsv.(
                                      Convert::GroupedHashToArray.(@species) ),
                    filename: "lets_species_avg_count_yearly-#{Date.today}.csv"}
      # format.csv {send_data
      #               Convert::ArrayToCsv.( grouped_hash_to_array(@species) ),
      #               filename: "lets_species_avg_count_yearly-#{Date.today}.csv"}
      # format.csv {send_data ArrayToCsv.new(
      #                       grouped_hash_to_array(@species) ).run,
      #               filename: "lets_species_avg_count_yearly-#{Date.today}.csv"}
    end
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
