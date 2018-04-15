require 'csv'

class TreeMeasurement < ApplicationRecord
  belongs_to :tree_specy
  belongs_to :tree_plot
  has_one    :transect,  through: :tree_plot

  # http://www.mattmorgante.com/technology/csv
  def self.import_csv(file)
    CSV.foreach(file.path, headers: true, :encoding => 'ISO-8859-1') do |row|
      tree = TreeMeasurement.new
      # lookup dependecies
      tree.tree_plot_id     = TreePlot.find_by(plot_code: row['plot'])&.id
      tree.tree_specy_id    = TreeSpecy.find_by(species_code: row['species_code'])&.id
      # associate data with fields
      tree.subquadrat       = row['subquadrat']
      tree.tree_label       = row['tree_label']
      tree.circumfrence_cm  = row['circumfrence_cm']
      # TODO: DATA USES US FORMAT!! (make flexible format detection)
      tree.measurement_date = Date.strptime(row['date'].to_s, '%m/%d/%Y')
      tree.save
    end
  end
  def self.to_csv( options={headers: true} )
    attributes = %w{transect_code tree_species_code tree_foilage_strategy
                    tree_plot_code subquadrat tree_label circumfrence_cm
                    tree_elevation_m tree_latitude tree_longitude
                    measurement_date}
    CSV.generate(options) do |csv|
      csv << attributes
      all.each do |tree|
        csv << attributes.map{ |attr| tree.send(attr) }
      end
    end
  end

  def transect_code
    transect.transect_code
  end
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

end
