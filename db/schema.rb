# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_03_28_182943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "plots", force: :cascade do |t|
    t.string "plot_name", null: false
    t.string "plot_code", null: false
    t.integer "elevation_m", null: false
    t.decimal "latitude", precision: 12, scale: 8, null: false
    t.decimal "longitude", precision: 12, scale: 8, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_plots_on_latitude_and_longitude"
  end

  create_table "trees", force: :cascade do |t|
    t.string "subquadrat"
    t.integer "tree_number"
    t.string "species", null: false
    t.integer "circumfrence_cm"
    t.date "measurement_date", null: false
    t.bigint "plot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["circumfrence_cm"], name: "index_trees_on_circumfrence_cm"
    t.index ["measurement_date"], name: "index_trees_on_measurement_date"
    t.index ["plot_id"], name: "index_trees_on_plot_id"
    t.index ["species"], name: "index_trees_on_species"
  end

  add_foreign_key "trees", "plots"
end
