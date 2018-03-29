require 'csv'

class TreeMeasurement < ApplicationRecord
  belongs_to :tree_specy
  belongs_to :tree_plot

  def tree_plot_code
    tree_plot.plot_code
  end
  def tree_species_code
    tree_specy.species_code
  end
  def tree_foilage_strategy
    tree_specy.foilage_strategy
  end
  def tree_elevation_m
    tree_plot.elevation_m
  end
  def tree_latitude
    tree_plot.latitude
  end
  def tree_longitude
    tree_plot.longitude
  end
  def self.to_csv( options={headers: true} )
    attributes = %w{  tree_plot_code tree_species_code tree_foilage_strategy
                      subquadrat tree_number circumfrence_cm
                      tree_elevation_m tree_latitude tree_longitude
                      measurement_date }
    CSV.generate(options) do |csv|
      csv << attributes
      all.each do |tree|
        csv << attributes.map{ |attr| tree.send(attr) }
      end
    end
  end
  # def self.to_csv(options = {})
  #   desired_columns = %w{ tree_plot_code tree_species_code
  #                         tree_foilage_strategy subquadrat tree_number
  #                         circumfrence_cm tree_elevation_m tree_latitude
  #                         tree_longitude measurement_date }
  #   CSV.generate(options) do |csv|
  #     csv << desired_columns
  #     all.each do |tree|
  #       csv << tree.attributes.values_at(*desired_columns)
  #     end
  #   end
  # end

end
