require 'csv'

csv_tree_data = File.read(Rails.root.join('db', 'data', 'LETS_Tree_Measurements.csv'))
csv_tree = CSV.parse(csv_tree_data, :headers => true, :encoding => 'ISO-8859-1')
csv_tree.each do |row|
  tree = TreeMeasurement.new
  tree.subquadrat       = row['subquadrat']
  tree.tree_label      = row['tree_label']
  tree.circumfrence_cm  = row['circumfrence_cm']
  tree.measurement_date = Date.strptime(row['date'].to_s, '%m/%d/%Y')
  tree.tree_specy_id    = TreeSpecy.find_by(species_code: row['species_code']).id
  tree.tree_plot_id     = TreePlot.find_by(plot_code: row['plot']).id
  if tree.save
    puts "SAVED: #{tree.inspect}"
  else
    puts "ERROR: #{tree.inspect}\n\t#{tree.error.messages}"
  end
end

puts "There are now #{TreeMeasurement.count} tree measurements"
