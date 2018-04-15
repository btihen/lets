class CreateTreeSpecies < ActiveRecord::Migration[5.2]
  def change
    create_table :tree_species do |t|
      t.citext :species_code, null: false
      t.string :species_name, null: false
      t.citext :foilage_strategy
      t.citext :foilage_type
      t.citext :taxonomy

      t.timestamps
    end
    add_index :tree_species, :species_code, unique: true
    add_index :tree_species, :species_name, unique: true
  end
end
