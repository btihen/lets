class CreateTreePlots < ActiveRecord::Migration[5.2]
  def change
    create_table :tree_plots do |t|
      t.citext   :plot_code,   null: false
      t.string   :plot_name,   null: false
      t.integer  :plot_slope
      t.integer  :plot_aspect
      t.integer  :elevation_m, null: false
      t.decimal  :latitude,    precision: 12, scale: 8, null: false
      t.decimal  :longitude,   precision: 12, scale: 8, null: false
      t.references :transect,  foreign_key: true

      t.timestamps
    end
    add_index :tree_plots, :plot_code, unique: true
    add_index :tree_plots, :plot_name, unique: true
    add_index :tree_plots, [:latitude, :longitude] #, unique: true
  end
end
