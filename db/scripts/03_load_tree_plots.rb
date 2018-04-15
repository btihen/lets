require 'csv'

csv_plot_data = File.read(Rails.root.join('db', 'data', 'LETS_Tree_Plots.csv'))
csv_plot = CSV.parse(csv_plot_data, :headers => true, :encoding => 'ISO-8859-1')
csv_plot.each do |row|
  plot = TreePlot.new
  plot.plot_name   = row['plot']
  plot.plot_code   = row['plot'].to_s.downcase
  plot.elevation_m = row['elevation_m']
  plot.latitude    = row['latitude']
  plot.longitude   = row['longitude']
  # only one plot for now - use transect code to lookup
  plot.transect_id = Transect.find_by(transect_code: 'ab_lets1').id
  if plot.save
    puts "SAVED: #{plot.inspect}"
  else
    puts "ERROR: #{plot.inspect}, #{plot.error.messages}"
  end
end

puts "There are now #{TreePlot.count} plots"
