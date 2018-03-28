# README

## TODO:

* add bootstrap (make a little prettier)
* provide home page
* export csv of data
* sample lessons on data analysis
* allow column sorts on tree data
* show a basic analysis
  - tree count at altitude by species
  - tree circumfrence at altitude by species

### collection protocol

http://lets-study.ch/lets-day-resources/measurement-protocols/plot-layout-process/


### raw data

https://docs.google.com/spreadsheets/d/1BsWKkM5g7P61u5PH2lzHftrtuqCwGOGtQYU8SHVJHrk/edit?ts=5aba4fee#gid=1235084934

```
# data munging

# remove "°" - degree symbol
cat LETS_Master_Data.csv | cut -d',' -f1,7-9 | sort | uniq | sed 's/°//g' > LETS_Plots_Data.csv

# remove decimals & "+" from data
cat LETS_Master_Data.csv | cut -d',' -f1-5,10 | sed 's/\.[0-9],/,/g' | sed 's/\+//' > LETS_Tree_Data.csv
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
