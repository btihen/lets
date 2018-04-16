require 'csv'

class Transect < ApplicationRecord
  # nested deletes - difficult (do by hand in conrtoller)
  # http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#module-ActiveRecord::Associations::ClassMethods-label-Delete+or+destroy-3F
  has_many :tree_plots
  # doesn't do nested deletes on purpose (protect against probs with join tables)
  # has_many :tree_plots, dependent: :destroy
  has_many :tree_measurements, through: :tree_plots
  has_many :transect_admin_editor, dependent: :destroy
  has_many :admins,            through: :transect_admin_editor

  validates :transect_code, presence: true, uniqueness: true
  validates :target_slope,  presence: true, numericality: {
                                interger_only: true,

                              }

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
