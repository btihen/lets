class CreateTrees < ActiveRecord::Migration[5.2]
  def change
    create_table :trees do |t|
      t.string  :plot_name
      t.decimal :plot_latitude,    precision: 10, scale: 7, null: false
      t.decimal :plot_longitude,   precision: 10, scale: 7, null: false
      t.string  :species,          null: false
      t.integer :circumfrence_cm,  null: false
      t.date    :measurement_date, null: false

      t.timestamps
    end
    add_index :trees, [:plot_latitude, :plot_longitude]
  end
end
