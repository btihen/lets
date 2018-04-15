require 'csv'

Transect.create!( transect_code: "ab_lets1",
                  transect_name: "Aigle-Berneuse-a210-s30",
                  target_slope: 30, target_aspect: 210)

# transect = Transect.new
# Transect.create!(name: "Aigle-Berneuse-1", code: "ab_lets1", slope: 30, aspect: 210)
# transect.save

# csv_transect_data = File.read(Rails.root.join('db', 'data', 'LETS_Transects.csv'))
# csv_transect = CSV.parse(csv_transect_data, :headers => true, :encoding => 'ISO-8859-1')
# csv_tree.each do |row|
#   transect = Transect.new
#   transect.transect_code = row['code']
#   transect.transect_name = row['name']
#   transect.target_slope  = row['slope']
#   transect.target_aspect = row['aspect']
#   if transect.save
#     puts "SAVED: #{transect.inspect}"
#   else
#     puts "ERROR: #{transect.inspect}\n\t#{transect.error.messages}"
#   end
# end
#
puts "There are now #{Transect.count} transects"
