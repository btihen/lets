class CreateTreePlots < ActiveRecord::Migration[5.2]
  def change
    create_table :tree_plots do |t|
      t.string  :plot_name,   null: false
      t.citext  :plot_code,   null: false
      t.integer :elevation_m, null: false
      t.decimal :latitude,    precision: 12, scale: 8, null: false
      t.decimal :longitude,   precision: 12, scale: 8, null: false

      t.timestamps
    end
    add_index :tree_plots, :plot_code, unique: true
    add_index :tree_plots, [:latitude, :longitude]
  end
end
