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
  end

  def species_longitudinal
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
