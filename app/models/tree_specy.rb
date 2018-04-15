require 'csv'

class TreeSpecy < ApplicationRecord
  has_many :tree_measurements, dependent: :destroy

  FOILAGE_STRATEGIES = %w[deciduous evergreen]
  FOILAGE_TYPES      = %w[broadleaf needle]
  TAXONOMIES         = %w[angiosperm conifer]

  # http://www.mattmorgante.com/technology/csv
  def self.import_csv(file)
    CSV.foreach(file.path, headers: true, :encoding => 'ISO-8859-1') do |row|
      TreeSpecy.create! row.to_hash
      # no dependencies - detailed matching not necessary
      # specy = TreeSpecy.new
      # specy.species_code     = row['species_code'].to_s.downcase
      # specy.species_name     = row['species_code']
      # specy.foilage_strategy = row['foilage_strategy']
      # specy.foilage_type     = row['foilage_type']
      # specy.taxonomy         = row['taxonomy']
    end
  end
  # easy - no depenencies
  def self.to_csv( options={headers: true} )
    attributes = %w{species_code species_name foilage_strategy foilage_type
                    taxonomy}
    CSV.generate(options) do |csv|
      csv << attributes
      all.each do |transect|
        csv << attributes.map{ |attr| transect.send(attr) }
      end
    end
  end

end
