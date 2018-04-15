require 'csv'

class Transect < ApplicationRecord
  has_many :tree_plots, dependent: :destroy
  has_many :admins,     through:   :transect_admin_editor

  validates :transect_code, presence: true, uniqueness: true
  validates :transect_name, presence: true, uniqueness: true

  # http://www.mattmorgante.com/technology/csv
  def self.import_csv(file)
    count_orig = Transect.count
    CSV.foreach(file.path, headers: true, :encoding => 'ISO-8859-1') do |row|
      transect = Transect.new row.to_hash
      transect.save  if transect.valid?
    end
    return (Transect.count - count_orig)
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
