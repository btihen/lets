class CreateTreeSpecies < ActiveRecord::Migration[5.2]
  def change
    create_table :tree_species do |t|
      t.string :species_name, null: false
      t.citext :species_code, null: false
      t.citext :foilage_strategy
      t.citext :foilage_type
      t.citext :taxonomy

      t.timestamps
    end
    add_index :tree_species, :species_code, unique: true
  end
end
