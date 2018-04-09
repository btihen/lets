require 'csv'

csv_species_data = File.read(Rails.root.join('db', 'data', 'LETS_Tree_Species.csv'))
csv_species = CSV.parse(csv_species_data, :headers => true, :encoding => 'ISO-8859-1')
csv_species.each do |row|
  species = TreeSpecy.new
  species.species_name       = row['species_code']
  species.species_code       = row['species_code'].to_s.downcase
  case row['foilage_strategy'].downcase
  when 'deciduous'
    species.taxonomy         = 'angiosperm'
    species.foilage_type     = 'broad leaf'
    species.foilage_strategy = 'deciduous'
  when 'conifer'
    species.taxonomy         = 'conifer'
    species.foilage_type     = 'needle'
    species.foilage_strategy = 'evergreen'
  else
    species.taxonomy         = 'unknown'
    species.foilage_type     = 'unknown'
    species.foilage_strategy = 'unknown'
  end
  if species.save
    puts "SAVED: #{species.inspect}"
  else
    puts "ERROR: #{species.inspect}\n\t#{species.error.messages}"
  end
end

puts "There are now #{TreeSpecy.count} tree species"
