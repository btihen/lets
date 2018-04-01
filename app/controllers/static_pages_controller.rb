class StaticPagesController < ApplicationController

  before_action :authenticate_admin!, only: []
    # except: [:home, :analysis_intro, :kite_graphing, :species_density, :yearly_growth]

  # project home
  def home
  end

  # Transect Data Collection
  def data_collection
  end

  # Transect Data Analysis
  def data_analysis
  end

  # explain how to make Kite Graphs
  def kite_graphs
  end

  def density
  end

  def species
  end

  def growth
  end

end
