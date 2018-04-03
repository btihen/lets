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
