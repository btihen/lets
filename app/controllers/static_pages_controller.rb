class StaticPagesController < ApplicationController

  before_action :authenticate_admin!, only: []
    # except: [:home, :analysis_intro, :kite_graphing, :species_density, :yearly_growth]

  # project home
  def home
  end

  # Transect Analysis Overview
  def overview
  end

  # explain how to make Kite Graphs
  def kite
  end

  def density
  end

  def species
  end

  def growth
  end

end
