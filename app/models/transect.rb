require 'csv'

class Transect < ApplicationRecord
  has_many :tree_plots, dependent: :destroy
  has_many :admins,     through:   :transect_admin_editor

  # http://www.mattmorgante.com/technology/csv
  def self.import_csv(file)
    CSV.foreach(file.path, headers: true, :encoding => 'ISO-8859-1') do |row|
      Transect.create! row.to_hash
    end
  end
  def self.to_csv( options={headers: true} )
    attributes = %w{transect_code transect_name
                    target_slope target_aspect}
    CSV.generate(options) do |csv|
      csv << attributes
      all.each do |transect|
        csv << attributes.map{ |attr| transect.send(attr) }
      end
    end
  end

end
