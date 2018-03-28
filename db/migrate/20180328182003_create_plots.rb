class CreatePlots < ActiveRecord::Migration[5.2]
  def change
    create_table :plots do |t|
      t.string  :plot_name, null: false
      t.string  :plot_code, null: false
      t.integer :elevation_m, null: false
      t.decimal :latitude,  precision: 12, scale: 8, null: false
      t.decimal :longitude, precision: 12, scale: 8, null: false

      t.timestamps
    end
    add_index :plots, :plot_code, unique: true
    add_index :plots, [:latitude, :longitude]
    add_index :plots, [:plot_code, :latitude, :longitude]
  end
end
