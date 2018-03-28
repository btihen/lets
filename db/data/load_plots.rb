require 'csv'

csv_plot_data = File.read(Rails.root.join('db', 'data', 'LETS_Plots_Data.csv'))
csv_plot = CSV.parse(csv_plot_data, :headers => true, :encoding => 'ISO-8859-1')
csv_plot.each do |row|
  plot = Plot.new
  plot.plot_name   = row['plot']
  plot.plot_code   = row['plot']
  plot.elevation_m = row['elevation_m']
  plot.latitude    = row['latitude']
  plot.longitude   = row['longitude']
  if plot.save
    puts "SAVED: #{plot.inspect}"
  else
    puts "ERROR: #{plot.inspect}, #{plot.error.messages}"
  end
end

puts "There are now #{Plot.count} plots"
