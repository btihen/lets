# LETS README

## app at:

* https://lets-analyze.herokuapp.com/
or
* https://lets-data.herokuapp.com/


## add a default users using the console:

```ruby
rails c
# https://stackoverflow.com/questions/4316940/create-a-devise-user-from-ruby-console
Admin.create!(email: "example@gmail.com", name: "First Last", password: "T0pSecr3t", password_confirmation: "T0pSecr3t")
exit
```

push data to heroku
```bash
# WITHOUT THE BASE USER
# get / dump dev database (compressed for heroku)
pg_dump -Fc --no-acl --no-owner -h localhost -U btihen lets_development > db/data/lets_data.dump
# pg_dump -Fc --no-acl --no-owner -h localhost -T admins -U btihen lets_development > db/data/lets_data_no_admin.dump
# get / dump human readable database
pg_dump --no-acl --no-owner -h localhost -T admins -U btihen lets_development > db/data/lets_data.sql
# restore dev database to heroku deployed app (needs to use compressed dump)
heroku pg:backups:restore --app lets-analyze 'https://github.com/btihen/lets/blob/master/db/data/lets_data.dump?raw=true' DATABASE_URL

heroku pg:backups:restore --app lets-analyze 'https://github.com/btihen/lets/blob/master/db/data/lets_data_no_admin.dump?raw=true' DATABASE_URL
```


## TODO:

**IT ToDos**
* write tests

**Basic Data Management**
* data updates?
* allow recursive plot deletes - with confirmation!
* allow recursive transect delete - with confirmation!

**Multi School TODOS:**
* Handle multiple editors (permission by transect)
* Handle selecting analysis by transect? (under what conditions)

**EDUCATIONAL TODOS:**
* add student youTube to home page
* tune lessons for LETS grade 9/10
* tune lessons for LETS grade 7/8 (Middle School)
* tune lessons for LETS grade 11/12 (IB Program)?
* show a basic analysis (publicly available)
  - tree count at altitude by species
  - tree circumference at altitude by species
* sample r code
* link to graphical r
* sample r code that can mine data from lets-analyze
* installing R (mac and windows) https://www.andrewheiss.com/blog/2012/04/17/install-r-rstudio-r-commander-windows-osx/
* R package for mac: http://cran.us.r-project.org/
* Visual R for mac: https://www.rstudio.com/products/rstudio/download/#download
* R server for linux: https://cran.rstudio.com/bin/linux/ubuntu/README.html (repo config) & https://www.rstudio.com/products/rstudio/download-server/ (server install after repo config)
* DataAnalysis Instruction (some of it free) - https://www.datacamp.com/onboarding

* kite graph article with R - https://rpubs.com/thoughtfulbloke/kitegraph

**Extra EDUCATIONAL TODOS:**
* add site photos?
* add species photos?
* add species info links?
* add auto-generated graphs?
* time based animations of graphs?
* geographical analysis / features?

**Extra FEATURES:**
* add paging on index page?
* add sortable columns on index page?
* helper method for code display (upcase)
* helper methods for name display (capitalize)
* allow nested attributes (for new trees and plots)?
* add cocoon for nested form on tree_measurements entry?

**TECH TESTS:**
* add FactoryBot
* add authorization tests
* add data validation and tests
* Allow admin profile edit page (& password change)
* test landing/lesson page (publicly available)
* test edit pages need (authentication)


### collection protocol

http://lets-study.ch/lets-day-resources/measurement-protocols/plot-layout-process/


### Original (start) Data

https://docs.google.com/spreadsheets/d/1BsWKkM5g7P61u5PH2lzHftrtuqCwGOGtQYU8SHVJHrk/edit?ts=5aba4fee#gid=1235084934


### build data Sets from original data
```bash
# data munging

# get PLOTS - remove "°" - degree symbol
cat LETS_Master_Data.csv | cut -d',' -f1,7-9 | sort | uniq | sed 's/°//g' > LETS_Plots_Data.csv

# get TREE Species
# (note1: LA,Deciduous & LA,Confir are both present so I made LA,Unknown)
# (note2: database now has
# * foliage_strategy (deciduous, evergreen & unknown)
# * foliage_type (broad_leaf & needle)
# * and taxonomy (cone, unknown)
cat LETS_Master_Data.csv | cut -d',' -f4,6 | sort | uniq | grep -v 'unknown,$' > LETS_Species_Data.csv

# remove decimals & "+" from data
# note: missing circumfences
cat LETS_Master_Data.csv | cut -d',' -f1-5,10 | sed 's/\.[0-9],/,/g' | sed 's/\+//' > LETS_Tree_Data.csv
```


### Build Models

```bash
rails new lets --database=postgresql
```

#### add postgres extensions

```ruby
class AddExtensions < ActiveRecord::Migration[5.2]
  def change
    enable_extension :citext
    # enable_extension :postgis
  end
end
```
**now setup the database**

```bash
rails db:create
rails db:migrate

# create tree_plot db table
rails g scaffold tree_plot plot_name:string plot_code:citext \
                      elevation_m:integer \
                      latitude:decimal longitude:decimal
```
#### Setup Plot DB

```ruby
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
```

```bash
# now add the data to the database (start rails console)
rails db:migrate
rails c
```
**COPY THE FOLLOWING INTO THE CONSOLE**

```ruby
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
```

#### create tree_species db table
**Model**
```bash
rails g scaffold tree_species species_name:string species_code:citext \
                      foilage_type:citext foilage_strategy:citext taxonomy:citext
```

```ruby
# adjust migration (add index)
class CreateTreeSpecies < ActiveRecord::Migration[5.2]
  def change
    create_table :tree_species do |t|
      t.string :species_name, null: false
      t.citext :species_code, null: false
      t.citext :foilage_strategy
      t.citext :foilage_type
      t.citext :taxonomy

      t.timestamps
    end
    add_index :tree_species, :species_code, unique: true
  end
end
```
```bash
# now load the database
rails db:migrate
rails c
```

```ruby
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
    # species.taxonomy        = ''
    species.foilage_type     = 'broad leaf'
    species.foilage_strategy = 'deciduous'
  when 'conifer'
    species.taxonomy        = 'cone'
    species.foilage_type     = 'needle'
    species.foilage_strategy = 'evergreen'
  else
    species.taxonomy        = 'unknown'
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
```

#### TREE measurements
**build model**
```bash
rails g scaffold tree_measurement circumfrence_cm:integer \
                      measurement_date:date \
                      subquadrat:citext \
                      tree_label:integer \
                      tree_specy:references tree_plot:references
```

**adjust db migrations**
```ruby
class CreateTreeMeasurements < ActiveRecord::Migration[5.2]
  def change
    create_table :tree_measurements do |t|
      t.integer  :circumfrence_cm
      t.date     :measurement_date, null: false
      t.citext   :subquadrat
      t.integer  :tree_label
      t.references :tree_specy, foreign_key: true
      t.references :tree_plot,  foreign_key: true

      t.timestamps
    end
    add_index :tree_measurements, :circumfrence_cm
    add_index :tree_measurements, :measurement_date
    add_index :tree_measurements, [ :tree_specy_id, :tree_plot_id,
                                    :subquadrat, :tree_label,
                                    :measurement_date ],
                                  unique: true,
                                  name: 'unique_tree_entries'
  end
end
```

**import data**
```bash
rails db:migrate
rails c
```
**run the import - copy the following code:**
```ruby
require 'csv'
csv_tree_data = File.read( Rails.root.join('db', 'data', 'LETS_Tree_Measurements.csv') )
csv_tree = CSV.parse(csv_tree_data, headers: true, encoding: 'ISO-8859-1')
csv_tree.each do |row|
  tree = TreeMeasurement.new
  tree.subquadrat       = row['subquadrat']
  tree.tree_label       = row['tree_label']
  tree.circumfrence_cm  = row['circumfrence_cm']
  tree.measurement_date = Date.strptime(row['date'].to_s, '%m/%d/%Y')
  tree.tree_specy_id    = TreeSpecy.find_by(species_code: row['species_code']).id
  tree.tree_plot_id     = TreePlot.find_by(plot_code: row['plot']).id
  if tree.save
    puts "Saved"
    # puts "SAVED: #{tree.inspect}"
  else
    puts "ERROR"
    # puts "ERROR: #{tree.inspect}\n\t#{tree.error.messages}"
  end
end
puts "There are now #{TreeMeasurement.count} tree measurements"
exit
```

#### adjust index page (to look like spreadsheet)

```html
# app/views/tree_measurements/index.html.erb
<p id="notice"><%= notice %></p>

<h1>Tree Measurements</h1>

<table>
  <thead>
    <tr>
      <th>Tree Plot</th>
      <th>Tree Specy</th>
      <th>Tree Foilage Strategy</th>
      <th>Tree Subquadrat</th>
      <th>Tree Label</th>
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
        <td><%= tree_measurement.tree_label %></td>
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
```

##########
# adjust show page for clarity
```html
# app/views/tree_measurements/show.html.erb
<p>
  <strong>Tree specy:</strong>
  <%= @tree_measurement.tree_specy.species_code %>
</p>

<p>
  <strong>Tree plot:</strong>
  <%= @tree_measurement.tree_plot.plot_code %>
</p>
```
##########
# fix tree_measurement input forms
```html
# app/views/tree_measurements/_form.html.erb
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

### Speed tree measurements with all data

```ruby
# pre-load related data
def index
  @tree_measurements = TreeMeasurement.includes(:tree_plot).
                                        includes(:tree_specy).all
end
```

### Add CSV & JSON export

```ruby
# app/models/tree_measurement.rb
require 'csv'

class TreeMeasurement < ApplicationRecord
  belongs_to :tree_specy
  belongs_to :tree_plot

  def tree_plot_code
    tree_plot.plot_code
  end
  def tree_species_code
    tree_specy.species_code
  end
  def tree_foilage_strategy
    tree_specy.foilage_strategy
  end
  def tree_elevation_m
    tree_plot.elevation_m
  end
  def tree_latitude
    tree_plot.latitude
  end
  def tree_longitude
    tree_plot.longitude
  end
  def self.to_csv( options={headers: true} )
    attributes = %w{  tree_plot_code tree_species_code tree_foilage_strategy
                      subquadrat tree_label circumfrence_cm
                      tree_elevation_m tree_latitude tree_longitude
                      measurement_date }
    CSV.generate(options) do |csv|
      csv << attributes
      all.each do |tree|
        csv << attributes.map{ |attr| tree.send(attr) }
      end
    end
  end
end
```
change the index method in the controller to:
```ruby
# app/controllers/tree_measurements_controller.rb
def index
  @tree_measurements = TreeMeasurement.includes(:tree_plot).
                                        includes(:tree_specy).all
  respond_to do |format|
    format.html
    format.json
    format.csv { send_data @tree_measurements.to_csv,
                      filename: "lets_tree_measurements-#{Date.today}.csv" }
  end
end
```

add the following links to the index page (just below the title):
```html
<h5>
  <%= link_to 'CSV Download', tree_measurements_path(format: :csv) %> |
  <%= link_to 'JSON Download', tree_measurements_path(format: :json) %>
</h5>
```

### allow edit by restricted users - only index for public

```ruby
# Gemfile
gem 'devise'
```
```bash
bundle install
rails generate devise:install
# Some setup you must do manually if you haven't yet:
#
#   1. Ensure you have defined default url options in your environments files. Here
#      is an example of default_url_options appropriate for a development environment
#      in config/environments/development.rb:
#
#        config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
#
#      In production, :host should be set to the actual host of your application.
#
#   2. Ensure you have defined root_url to *something* in your config/routes.rb.
#      For example:
#
#        root to: "tree_measurements#index"
#
#   3. Ensure you have flash messages in app/views/layouts/application.html.erb.
#      For example:
#
#        <p class="notice"><%= notice %></p>
#        <p class="alert"><%= alert %></p>

rails generate devise admin
rails db:migrate
rails g devise:views admins
```

add restrictions:
```ruby
# apps/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_admin!
end
```
and exception for index page:
```ruby
# apps/controllers/tree_measurements_controller.rb
class TreeMeasurementsController < ApplicationController
  before_action :authenticate_admin!, except: [:index]
```


## add a default users using the console:

```ruby
rails c
# https://stackoverflow.com/questions/4316940/create-a-devise-user-from-ruby-console
Admin.create!(email: "example@gmail.com", name: "First Last", password: "T0pSecr3t", password_confirmation: "T0pSecr3t")
exit
```

push data to heroku
```bash
# WITHOUT THE BASE USER
# get / dump dev database (compressed for heroku)
pg_dump -Fc --no-acl --no-owner -h localhost -U btihen lets_development > db/data/lets_data.dump
# pg_dump -Fc --no-acl --no-owner -h localhost -T admins -U btihen lets_development > db/data/lets_data.dump
# get / dump human readable database
pg_dump --no-acl --no-owner -h localhost -T admins -U btihen lets_development > db/data/lets_data.sql
# restore dev database to heroku deployed app (needs to use compressed dump)
heroku pg:backups:restore --app lets-analyze 'https://github.com/btihen/lets/blob/master/db/data/lets_data.dump?raw=true' DATABASE_URL
```
## ANALYSIS
*  graph tree distribution (in a transect) use a kite graph (traditional by species at altitued (dynamic by year?) & select a single species and x is year and altitudes is vertical)
*  graph tree diagrams using a ?Bubble? graph - bubble size proportional to tree diameter

examples/articles of a kite graph at:
* http://ib.bioninja.com.au/options/option-c-ecology-and-conser/c1-species-and-communities/species-distribution.html
* transect mapping (kite diagrams) for density and counts - https://www.youtube.com/watch?v=_yKtAHhTF50
* https://www.youtube.com/watch?v=Qk9keR_wyvY - animal distritution
* Kite Diagram in R - https://stackoverflow.com/questions/22201025/create-kite-diagram-in-r
* Kite Diagram in Excel - http://bluesquarething.co.uk/geography/kite.htm
* https://www.geoib.com/graphs--charts.html

## Web Analysis Options (JS Graphing Options)
- options: https://en.wikipedia.org/wiki/JavaScript_graphics_library
* plotty.js - https://plot.ly/javascript/ (looks easy and focused on graping data) - 2D density plot example at: https://plot.ly/javascript/2d-density-plots/
* chartjs - simple, elegant and responsive (with animation) - http://www.chartjs.org/
* plotly.js (does all we need - but expensive) - https://github.com/plotly/plotly.js/ - built to simplify d3
* dash - https://github.com/plotly/dash
* anychart.js - https://www.anychart.com/features/#chart-types - https://docs.anychart.com/Basic_Charts/Heat_Map_Chart (license?)
* d3.js - https://github.com/d3/d3/wiki/Gallery - the motion chart might be useful



## EPLORING SQL for Data Analysis

# https://blog.bigbinary.com/2016/03/24/support-for-left-outer-joins-in-rails-5.html
# get every unique altitude
altitudes = TreePlot.distinct.pluck(:elevation_m).sort
# get each uniqe species
species = TreeSpecy.distinct
# get every unique year
# https://stackoverflow.com/questions/9624601/activerecord-find-by-year-day-or-month-on-a-date-field
# https://stackoverflow.com/questions/29028049/find-unique-months-and-years-from-date
dates = TreeMeasurement.distinct.pluck(:measurement_date).sort

# sum the number of species at each altitude for each species - for a given year
# return table:
# Elevation | Species 1 | Species 2
#     0     |     0     |     5
#    500    |     2     |     3
#   1000    |     4     |     0
# ideally group by year!
select tree_plots.plot_code, tree_plots.elevation_m,
tree_measurements.measurement_date, tree_measurements.tree_specy_id
from tree_plots
left join tree_measurements on tree_plots.id = tree_measurements.tree_plot_id
order by tree_plots.elevation_m, tree_measurements.tree_specy_id;
# plot_code | elevation_m | measurement_date | tree_specy_id
# -----------+-------------+------------------+---------------
# ttfp      |           0 | 2015-10-01       |            27
# ttfp      |           0 | 2015-10-01       |            27
# ttfp      |           0 | 2015-10-01       |            27
# ttfp      |           0 | 2015-10-01       |            27
# ttfp      |           0 | 2015-10-01       |            27
# ttfp      |           0 | 2015-10-01       |            27
# ttfp      |           0 | 2015-10-01       |            34
# ttfp      |           0 | 2015-10-01       |            36
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            10
# lafp      |         542 | 2017-10-10       |            12
# lafp      |         542 | 2017-10-10       |            12
# lafp      |         542 | 2017-10-10       |            12
# lafp      |         542 | 2017-10-10       |            12
# lafp      |         542 | 2017-10-10       |            12
# lafp      |         542 | 2017-10-10       |            12
# lafp      |         542 | 2017-10-10       |            12
# lafp      |         542 | 2017-10-10       |            12

select tree_plots.plot_code, tree_plots.elevation_m, count(tree_measurements.tree_specy_id)
from tree_plots
left join tree_measurements on tree_plots.id = tree_measurements.tree_plot_id
group by tree_plots.elevation_m, tree_measurements.measurement_date, tree_measurements.tree_specy_id
order by tree_plots.elevation_m, tree_measurements.measurement_date;
#  plot_code | elevation_m | count
# -----------+-------------+-------
#  ttfp      |           0 |     8
#  lafp      |         542 |    33
#  pdfp      |         667 |   177
#  refp      |         933 |    94
#  vdfp      |        1000 |    22
#  lrfp      |        1116 |   194
#  dpfp      |        1205 |   129
#  lsfp      |        1213 |   155
#  bgfp      |        1270 |   167
#  stfp      |        1277 |   162
#  crfp      |        1362 |   135
#  brfp2     |        1419 |    56
#  brfp1     |        1419 |   103
#  befp      |        1478 |   139
#  befp2     |        1478 |    36
#  befp1     |        1478 |    36
#  bpfp      |        1703 |   152
#  sofp      |        1844 |   112
#  rifp      |        1902 |    39

# https://www.w3schools.com/sql/sql_join_left.asp
# https://www.w3schools.com/sql/sql_count_avg_sum.asp
# https://www.w3schools.com/sql/sql_groupby.asp
select tree_plots.plot_code, tree_plots.elevation_m,
tree_measurements.measurement_date, tree_measurements.tree_specy_id,
count(tree_measurements.tree_specy_id)
from tree_plots
left join tree_measurements
on tree_plots.id = tree_measurements.tree_plot_id
group by tree_plots.plot_code, tree_plots.elevation_m, tree_measurements.measurement_date,
tree_measurements.tree_specy_id
order by tree_plots.elevation_m, tree_measurements.measurement_date, tree_measurements.tree_specy_id;
# plot_code | elevation_m | measurement_date | tree_specy_id | count
# -----------+-------------+------------------+---------------+-------
# ttfp      |           0 | 2015-10-01       |            27 |     6
# ttfp      |           0 | 2015-10-01       |            34 |     1
# ttfp      |           0 | 2015-10-01       |            36 |     1
# lafp      |         542 | 2017-10-10       |            10 |    13
# lafp      |         542 | 2017-10-10       |            12 |     8
# lafp      |         542 | 2017-10-10       |            30 |     8
# lafp      |         542 | 2017-10-10       |            39 |     4
# pdfp      |         667 | 2015-05-01       |             5 |     1
# pdfp      |         667 | 2015-05-01       |             8 |     3
# pdfp      |         667 | 2015-05-01       |            10 |     8
# pdfp      |         667 | 2015-05-01       |            30 |     4
# pdfp      |         667 | 2015-05-01       |            31 |     2
# pdfp      |         667 | 2015-05-01       |            35 |     1
# pdfp      |         667 | 2015-05-01       |            40 |     7
# pdfp      |         667 | 2015-05-01       |            41 |     2
# pdfp      |         667 | 2015-10-01       |             8 |     8
# pdfp      |         667 | 2015-10-01       |            27 |     1
# pdfp      |         667 | 2015-10-01       |            30 |    15
# pdfp      |         667 | 2015-10-01       |            39 |    11
# pdfp      |         667 | 2015-10-01       |            40 |     3
# pdfp      |         667 | 2015-10-01       |            41 |    17
# pdfp      |         667 | 2016-05-01       |            10 |    15
# pdfp      |         667 | 2016-05-01       |            27 |     4
# pdfp      |         667 | 2016-05-01       |            30 |    17
# pdfp      |         667 | 2016-05-01       |            33 |     4
# pdfp      |         667 | 2016-10-11       |             3 |     3
# pdfp      |         667 | 2016-10-11       |            10 |     4
# pdfp      |         667 | 2016-10-11       |            12 |     1
# pdfp      |         667 | 2016-10-11       |            21 |     1


# https://www.w3schools.com/sql/sql_join_left.asp
# https://www.w3schools.com/sql/sql_count_avg_sum.asp
# https://www.w3schools.com/sql/sql_groupby.asp
# https://stackoverflow.com/questions/10195451/sql-inner-join-with-3-tables
select tree_plots.plot_code, tree_plots.elevation_m,
tree_measurements.measurement_date,
tree_species.species_code,
count(tree_measurements.tree_specy_id) as species_plot_count
from tree_plots
left join tree_measurements
on tree_plots.id = tree_measurements.tree_plot_id
inner join tree_species
on tree_measurements.tree_specy_id = tree_species.id
group by tree_plots.plot_code, tree_plots.elevation_m, tree_measurements.measurement_date,
tree_species.species_code
order by tree_plots.elevation_m, tree_measurements.measurement_date,
tree_species.species_code;
#  plot_code | elevation_m | measurement_date |   species_code    | species_density
# -----------+-------------+------------------+-------------------+-----------------
#  ttfp      |           0 | 2015-10-01       | ns                |               6
#  ttfp      |           0 | 2015-10-01       | spruce bush       |               1
#  ttfp      |           0 | 2015-10-01       | st                |               1
#  lafp      |         542 | 2017-10-10       | eb                |              13
#  lafp      |         542 | 2017-10-10       | ey                |               8
#  lafp      |         542 | 2017-10-10       | sf                |               8
#  lafp      |         542 | 2017-10-10       | uc                |               4
#  pdfp      |         667 | 2015-05-01       | broad-leaved lime |               1
#  pdfp      |         667 | 2015-05-01       | ea                |               3
#  pdfp      |         667 | 2015-05-01       | eb                |               8
#  pdfp      |         667 | 2015-05-01       | sf                |               4
#  pdfp      |         667 | 2015-05-01       | sm                |               2
#  pdfp      |         667 | 2015-05-01       | small-leaved lime |               1
#  pdfp      |         667 | 2015-05-01       | ud                |               7
#  pdfp      |         667 | 2015-05-01       | unknown           |               2
#  pdfp      |         667 | 2015-10-01       | ea                |               8
#  pdfp      |         667 | 2015-10-01       | ns                |               1
#  pdfp      |         667 | 2015-10-01       | sf                |              15
#  pdfp      |         667 | 2015-10-01       | uc                |              11
#  pdfp      |         667 | 2015-10-01       | ud                |               3
#  pdfp      |         667 | 2015-10-01       | unknown           |              17
#  pdfp      |         667 | 2016-05-01       | eb                |              15
#  pdfp      |         667 | 2016-05-01       | ns                |               4
#  pdfp      |         667 | 2016-05-01       | sf                |              17
#  pdfp      |         667 | 2016-05-01       | sp                |               4
#  pdfp      |         667 | 2016-10-11       | ba                |               3
#  pdfp      |         667 | 2016-10-11       | eb                |               4
#  pdfp      |         667 | 2016-10-11       | ey                |               1
#  pdfp      |         667 | 2016-10-11       | li                |               1
#  pdfp      |         667 | 2016-10-11       | ns                |               5
#  pdfp      |         667 | 2016-10-11       | sf                |              16
#  pdfp      |         667 | 2016-10-11       | uc                |               1
#  pdfp      |         667 | 2016-10-11       | wa                |               3
#  pdfp      |         667 | 2017-10-10       | uc                |              13
#  pdfp      |         667 | 2017-10-10       | ud                |               7

# https://stackoverflow.com/questions/2337510/ruby-can-i-write-multi-line-string-with-no-concatenation
# https://stackoverflow.com/questions/14824453/rails-raw-sql-example
# sql = "Select * from ... your sql query here"
# sql = %{
# SELECT user, name
# FROM users
# WHERE users.id = #{var}
# LIMIT #{var2}
# }
sql = %{
SELECT tree_plots.plot_code, tree_plots.elevation_m,
tree_measurements.measurement_date,
tree_species.species_code,
COUNT(tree_measurements.tree_specy_id) as species_plot_count
FROM tree_plots
LEFT JOIN tree_measurements
ON tree_plots.id = tree_measurements.tree_plot_id
INNER JOIN tree_species
ON tree_measurements.tree_specy_id = tree_species.id
GROUP ON by tree_plots.plot_code, tree_plots.elevation_m,
tree_measurements.measurement_date, tree_species.species_code
ORDER BY tree_plots.elevation_m, tree_measurements.measurement_date,
tree_species.species_code
}
records_array = ActiveRecord::Base.connection.execute(sql)
