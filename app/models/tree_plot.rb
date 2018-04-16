require 'csv'

class TreePlot < ApplicationRecord
  belongs_to :transect
  has_many   :tree_measurements, dependent: :destroy

  validates :plot_code, presence: true, uniqueness: true
  validates :plot_name, presence: true, uniqueness: true
  validates :latitude,  presence: true, numericality: {
                                        less_than_or_equal_to:     90,
                                        greater_than_or_equal_to: -90 }
  validates :longitude, presence: true, numericality: {
                                        less_than_or_equal_to:     180,
                                        greater_than_or_equal_to: -180 }

  # http://www.mattmorgante.com/technology/csv
  def self.import_csv(file)
    count_orig = TreePlot.count
    transect_hash = Transect.pluck(:transect_code, :id).to_h
    CSV.foreach(file.path, headers: true, :encoding => 'ISO-8859-1') do |row|
      plot = TreePlot.new
      # lookup dependecies
      # plot.transect_id = Transect.find_by(transect_code: row['transect_code'])&.id
      # problem when bad entry not in list
      # next if transect_hash[row[:transect_code]].nil?
      plot.transect_id = transect_hash[row['transect_code']]
      plot.plot_code   = row['plot_code'].to_s.downcase
      plot.plot_name   = row['plot_name']
      plot.elevation_m = row['elevation_m']
      plot.plot_slope  = row['plot_slope']
      plot.plot_aspect = row['plot_aspect']
      plot.latitude    = row['latitude']
      plot.longitude   = row['longitude']
      plot.save       if plot.valid?
    end
    return (TreePlot.count - count_orig)
  end
  def self.to_csv( options={headers: true} )
    attributes = %w{transect_code plot_code plot_name elevation_m
                    plot_slope plot_aspect latitude longitude}
    CSV.generate(options) do |csv|
      csv << attributes
      all.each do |transect|
        csv << attributes.map{ |attr| transect.send(attr) }
      end
    end
  end

  def transect_code
    transect.transect_code
  end

end
