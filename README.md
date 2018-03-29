# README

## TODO:

* add bootstrap (make a little prettier)
* make landing page
* push to heroku with data
* add FactoryBot & basic tests
* export csv of data
* add paging
* add speed (pre-loading)
* sample lessons on data analysis
* allow column sorts on tree data
* show a basic analysis
  - tree count at altitude by species
  - tree circumfrence at altitude by species

### collection protocol

http://lets-study.ch/lets-day-resources/measurement-protocols/plot-layout-process/


### build data Sets

https://docs.google.com/spreadsheets/d/1BsWKkM5g7P61u5PH2lzHftrtuqCwGOGtQYU8SHVJHrk/edit?ts=5aba4fee#gid=1235084934

```bash
# data munging

# get PLOTS - remove "°" - degree symbol
cat LETS_Master_Data.csv | cut -d',' -f1,7-9 | sort | uniq | sed 's/°//g' > LETS_Plots_Data.csv

# get TREE Species
# (note1: LA,Deciduous & LA,Confir are both present so I made LA,Unknown)
# (note2: database now has
# * foliage_strategy (deciduous, evergreen & unknown)
# * foliage_type (broad_leaf & needle)
# * and seed_type (cone, unknown)
cat LETS_Master_Data.csv | cut -d',' -f4,6 | sort | uniq | grep -v 'unknown,$' > LETS_Species_Data.csv

# remove decimals & "+" from data
# note: missing circumfences
cat LETS_Master_Data.csv | cut -d',' -f1-5,10 | sed 's/\.[0-9],/,/g' | sed 's/\+//' > LETS_Tree_Data.csv
```


### Build Models

rails new lets --database=postgresql

# add postgres extensions
#########################
class AddExtensions < ActiveRecord::Migration[5.2]
  def change
    enable_extension :citext
    # enable_extension :postgis
  end
end

# now setup the database
rails db:create
rails db:migrate

# create tree_plot db table
rails g scaffold tree_plot plot_name:string plot_code:citext \
                      elevation_m:integer \
                      latitude:decimal longitude:decimal

# update tree_plot db migration to be:
class CreateTreePlots < ActiveRecord::Migration[5.2]
  def change
    create_table :tree_plots do |t|
      t.string :plot_name,    null: false
      t.citext :plot_code,    null: false
      t.integer :elevation_m, null: false
      t.decimal :latitude,    precision: 12, scale: 8, null: false
      t.decimal :longitude,   precision: 12, scale: 8, null: false

      t.timestamps
    end
    add_index :tree_plots, :plot_code, unique: true
    add_index :tree_plots, [:latitude, :longitude]
  end
end

# now add the data to the database (start rails console)
rails db:migrate
rails c
# COPY THE FOLLOWING INTO THE CONSOLE
require 'csv'
csv_plot_data = File.read(Rails.root.join('db', 'data', 'LETS_Tree_Plots.csv'))
csv_plot = CSV.parse(csv_plot_data, :headers => true, :encoding => 'ISO-8859-1')
csv_plot.each do |row|
  plot = TreePlot.new
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
puts "There are now #{TreePlot.count} plots"
# to leave type
exit


# create tree_species db table
##############################
rails g scaffold tree_species species_name:string species_code:citext \
                      foilage_type:citext foilage_strategy:citext seed_type:citext

# adjust migration (add index)
class CreateTreeSpecies < ActiveRecord::Migration[5.2]
  def change
    create_table :tree_species do |t|
      t.string :species_name, null: false
      t.citext :species_code, null: false
      t.citext :foilage_strategy
      t.citext :foilage_type
      t.citext :seed_type

      t.timestamps
    end
    add_index :tree_species, :species_code, unique: true
  end
end

# now load the database
rails db:migrate
rails c
# copy into the console
require 'csv'
csv_species_data = File.read(Rails.root.join('db', 'data', 'LETS_Tree_Species.csv'))
csv_species = CSV.parse(csv_species_data, :headers => true, :encoding => 'ISO-8859-1')
csv_species.each do |row|
  species = TreeSpecy.new
  species.species_name     = row['species_code']
  species.species_code     = row['species_code'].downcase
  case row['foilage_strategy'].downcase
  when 'deciduous'
    # species.seed_type        = ''
    species.foilage_type     = 'broad leaf'
    species.foilage_strategy = 'deciduous'
  when 'conifer'
    species.seed_type        = 'cone'
    species.foilage_type     = 'needle'
    species.foilage_strategy = 'evergreen'
  else
    species.seed_type        = 'unknown'
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
exit

# TREE measurements
###################
rails g scaffold tree_measurement circumfrence_cm:integer \
                      measurement_date:date \
                      subquadrat:citext \
                      tree_number:integer \
                      tree_specy:references tree_plot:references
# adjust db migrations
class CreateTreeMeasurements < ActiveRecord::Migration[5.2]
  def change
    create_table :tree_measurements do |t|
      t.integer  :circumfrence_cm
      t.date     :measurement_date, null: false
      t.citext   :subquadrat
      t.integer  :tree_number
      t.references :tree_specy, foreign_key: true
      t.references :tree_plot,  foreign_key: true

      t.timestamps
    end
    add_index :tree_measurements, :circumfrence_cm
    add_index :tree_measurements, :measurement_date
    add_index :tree_measurements, [ :tree_specy_id, :tree_plot_id,
                                    :subquadrat, :tree_number,
                                    :measurement_date ],
                                  unique: true,
                                  name: 'unique_tree_entries'
  end
end

# import data
rails db:migrate
rails c
# copy the following code:
require 'csv'
csv_tree_data = File.read(Rails.root.join('db', 'data', 'LETS_Tree_Measurements.csv'))
csv_tree = CSV.parse(csv_tree_data, :headers => true, :encoding => 'ISO-8859-1')
csv_tree.each do |row|
  tree = TreeMeasurement.new
  tree.subquadrat       = row['subquadrat']
  tree.tree_number      = row['tree_number']
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
exit


```

```ruby
# adjust index page (to look like spreadsheet)
#####
<p id="notice"><%= notice %></p>

<h1>Tree Measurements</h1>

<table>
  <thead>
    <tr>
      <th>Tree Plot</th>
      <th>Tree Specy</th>
      <th>Tree Foilage Strategy</th>
      <th>Tree Subquadrat</th>
      <th>Tree Number</th>
      <th>Tree Circumfrence (cm)</th>
      <th>Tree Elevation (m)</th>
      <th>Tree Latitude</th>
      <th>Tree Longitude</th>
      <th>Tree Measurement Date</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @tree_measurements.each do |tree_measurement| %>
      <tr>
        <td><%= tree_measurement.tree_plot.plot_code %></td>
        <td><%= tree_measurement.tree_specy.species_code %></td>
        <td><%= tree_measurement.tree_specy.foilage_strategy %></td>
        <td><%= tree_measurement.subquadrat %></td>
        <td><%= tree_measurement.tree_number %></td>
        <td><%= tree_measurement.circumfrence_cm %></td>
        <td><%= tree_measurement.tree_plot.elevation_m %></td>
        <td><%= tree_measurement.tree_plot.latitude %></td>
        <td><%= tree_measurement.tree_plot.longitude %></td>
        <td><%= tree_measurement.measurement_date %></td>
        <td><%= link_to 'Show', tree_measurement %></td>
        <td><%= link_to 'Edit', edit_tree_measurement_path(tree_measurement) %></td>
        <td><%= link_to 'Destroy', tree_measurement, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New Tree Measurement', new_tree_measurement_path %>
##########
# adjust show page for clarity
##
<p>
  <strong>Tree specy:</strong>
  <%= @tree_measurement.tree_specy.species_code %>
</p>

<p>
  <strong>Tree plot:</strong>
  <%= @tree_measurement.tree_plot.plot_code %>
</p>
##########
# fix tree_measurement input forms
<div class="field">
  <%= form.label :tree_plot_id %>
  <%= form.collection_select :tree_plot_id, TreePlot.order(:plot_code),
                              :id, :plot_code, include_blank: true %>
</div>

<div class="field">
  <%= form.label :tree_specy_id %>
  <%= form.collection_select :tree_specy_id, TreeSpecy.order(:species_code),
                              :id, :species_code, include_blank: true %>
</div>
```
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
