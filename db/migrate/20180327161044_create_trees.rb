class CreateTrees < ActiveRecord::Migration[5.2]
  def change
    create_table :trees do |t|
      t.string :plot_name
      t.string :species_code
      t.integer :circumfrence_bh_cm
      t.integer :elevation_meters
      t.date :measurement_date

      t.timestamps
    end
  end
end
