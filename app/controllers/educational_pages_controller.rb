class EducationalPagesController < ApplicationController

  before_action :authenticate_admin!, only: []

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

    respond_to do |format|
      format.html
      format.json
      format.csv  {send_data Convert::SqlToCsv.new(@species).run,
                    filename: "lets_species_count_by_date-#{Date.today}.csv"}
    end
  end

  def species_avg_by_date
    # get the sql species counted by plot and averaged by year
    species_by_elevation = SqlQueries::Species.(:date_avg_by_elevation)

    # convert data sets (years) to pivot tables
    @species = data_sets_to_pivot_tables(species_by_elevation, 'measurement_date')
    
    respond_to do |format|
      format.html
      format.json
      # format.json  { render json: { "language" => @languages.as_json(:root => false) }.to_json }
      # species averaged by year in pivot table format
      format.csv {send_data Convert::ArrayToCsv.(
                                      Convert::GroupedHashToArray.(@species) ),
                    filename: "lets_species_avg_count_by_date-#{Date.today}.csv"}
    end
  end

  def species_avg_by_year
    # get the sql species counted by plot and averaged by year
    species_by_elevation = SqlQueries::Species.(:yearly_avg_by_elevation )

    # convert data sets (years) to pivot tables
    @species = data_sets_to_pivot_tables(species_by_elevation, 'year')

    respond_to do |format|
      format.html
      format.json
      # format.json  { render json: { "language" => @languages.as_json(:root => false) }.to_json }
      # species averaged by year in pivot table format
      format.csv {send_data Convert::ArrayToCsv.(
                                      Convert::GroupedHashToArray.(@species) ),
                    filename: "lets_species_avg_count_yearly-#{Date.today}.csv"}
    end
  end

  def species_longitudinal
    # # get every unique altitude
    # altitudes = TreePlot.distinct.pluck(:elevation_m).sort
    # # get each uniqe species
    # species = TreeSpecy.distinct
    # # get every unique year
    # # sum the number of species at each altitude each year - for a given species
    # # return table:
    # # Elevation | Year 1 | Year 2
    # #     0     |    0   |    5
    # #    500    |    2   |    3
    # #   1000    |    4   |    0
    # # ideally group by species!
  end

  def species_animated
  end

  def growth_elevation
  end

  def growth_longitudinal
  end

  def growth_animated
  end

  private

  def data_sets_to_pivot_tables(data_sets, sets_key)
    # sort sql by the set key (test its there?)
    data_grouped = data_sets.group_by{ |r| r[sets_key] }

    # convert each year of data to a pivot table
    pivot_tables = {}
    data_grouped.each do |key, vals|
      pivot_tables[key] = Convert::SqlToPivotArray.new(vals, :tree_species).run
    end
    return pivot_tables
  end

end
