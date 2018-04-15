require 'csv'

class TransectAdminEditor < ApplicationRecord
  belongs_to :transect
  belongs_to :admin

  # http://www.mattmorgante.com/technology/csv
  def self.import(file)
    CSV.foreach(file.path, headers: true, :encoding => 'ISO-8859-1') do |row|
      editor = TransectAdminEditor.new
      # lookup dependecies
      editor.admin_id    = Admin.find_by(email: row['email'])&.id
      editor.transect_id = Transect.find_by(transect_code: row['transect_code'])&.id
    end
  end
  def self.to_csv( options={headers: true} )
    attributes = %w{transect_code email}
    CSV.generate(options) do |csv|
      csv << attributes
      all.each do |transect|
        csv << attributes.map{ |attr| transect.send(attr) }
      end
    end
  end

end
