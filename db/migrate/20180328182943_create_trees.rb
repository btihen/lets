class CreateTrees < ActiveRecord::Migration[5.2]
  def change
    create_table :trees do |t|
      t.string  :subquadrat
      t.integer :tree_number
      t.string  :species,          null: false
      t.integer :circumfrence_cm #,  null: false
      t.date    :measurement_date, null: false
      t.references :plot, foreign_key: true

      t.timestamps
    end
    add_index :trees, :species
    add_index :trees, :circumfrence_cm
    add_index :trees, :measurement_date
    add_index :trees, [:species, :subquadrat, :tree_number, :measurement_date],
                      unique: true, name: 'unique_tree_measurements'
  end
end
