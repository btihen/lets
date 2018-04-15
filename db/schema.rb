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

ActiveRecord::Schema.define(version: 2018_04_15_085511) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.citext "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "transect_admin_editors", force: :cascade do |t|
    t.bigint "transect_id"
    t.bigint "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_transect_admin_editors_on_admin_id"
    t.index ["transect_id", "admin_id"], name: "index_transect_admin_editors_on_transect_id_and_admin_id", unique: true
    t.index ["transect_id"], name: "index_transect_admin_editors_on_transect_id"
  end

  create_table "transects", force: :cascade do |t|
    t.citext "transect_code"
    t.string "transect_name"
    t.integer "target_slope"
    t.integer "target_aspect"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transect_code"], name: "index_transects_on_transect_code", unique: true
    t.index ["transect_name"], name: "index_transects_on_transect_name", unique: true
  end

  create_table "tree_measurements", force: :cascade do |t|
    t.integer "circumfrence_cm"
    t.date "measurement_date", null: false
    t.citext "subquadrat"
    t.integer "tree_label"
    t.bigint "tree_specy_id"
    t.bigint "tree_plot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["circumfrence_cm"], name: "index_tree_measurements_on_circumfrence_cm"
    t.index ["measurement_date"], name: "index_tree_measurements_on_measurement_date"
    t.index ["tree_plot_id"], name: "index_tree_measurements_on_tree_plot_id"
    t.index ["tree_specy_id", "tree_plot_id", "subquadrat", "tree_label", "measurement_date"], name: "unique_tree_entries", unique: true
    t.index ["tree_specy_id"], name: "index_tree_measurements_on_tree_specy_id"
  end

  create_table "tree_plots", force: :cascade do |t|
    t.citext "plot_code", null: false
    t.string "plot_name", null: false
    t.integer "plot_slope"
    t.integer "plot_aspect"
    t.integer "elevation_m", null: false
    t.decimal "latitude", precision: 12, scale: 8, null: false
    t.decimal "longitude", precision: 12, scale: 8, null: false
    t.bigint "transect_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_tree_plots_on_latitude_and_longitude"
    t.index ["plot_code"], name: "index_tree_plots_on_plot_code", unique: true
    t.index ["plot_name"], name: "index_tree_plots_on_plot_name", unique: true
    t.index ["transect_id"], name: "index_tree_plots_on_transect_id"
  end

  create_table "tree_species", force: :cascade do |t|
    t.citext "species_code", null: false
    t.string "species_name", null: false
    t.citext "foilage_strategy"
    t.citext "foilage_type"
    t.citext "taxonomy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["species_code"], name: "index_tree_species_on_species_code", unique: true
    t.index ["species_name"], name: "index_tree_species_on_species_name", unique: true
  end

  add_foreign_key "transect_admin_editors", "admins"
  add_foreign_key "transect_admin_editors", "transects"
  add_foreign_key "tree_measurements", "tree_plots"
  add_foreign_key "tree_measurements", "tree_species"
  add_foreign_key "tree_plots", "transects"
end
