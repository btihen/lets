class CreateTreeSpecies < ActiveRecord::Migration[5.2]
  def change
    create_table :tree_species do |t|
      t.citext :species_code,     null: false
      t.string :species_name
      t.citext :foilage_strategy, null: false
      t.citext :foilage_type,     null: false
      t.citext :taxonomy,         null: false

      t.timestamps
    end
    add_index :tree_species, :species_code, unique: true
  end
end
