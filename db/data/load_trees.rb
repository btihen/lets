require 'csv'

csv_tree_data = File.read(Rails.root.join('db', 'data', 'LETS_Tree_Data.csv'))
csv_tree = CSV.parse(csv_tree_data, :headers => true, :encoding => 'ISO-8859-1')
csv_tree.each do |row|
  tree = Tree.new
  tree.plot_id          = Plot.find_by(plot_code: row['plot']).id
  tree.subquadrat       = row['subquadrat']
  tree.tree_number      = row['tree_number']
  tree.species          = row['species_code']
  tree.circumfrence_cm  = row['circumfrence_cm']
  tree.measurement_date = Date.strptime(row['date'].to_s, '%m/%d/%Y')
  if tree.save
    puts "SAVED: #{tree.inspect}"
  else
    puts "ERROR: #{tree.inspect}\n\t#{tree.error.messages}"
  end
end

puts "There are now #{Tree.count} tree measurements"
