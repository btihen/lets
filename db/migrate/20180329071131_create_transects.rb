class CreateTransects < ActiveRecord::Migration[5.2]
  def change
    create_table :transects do |t|
      t.citext  :transect_code
      t.string  :transect_name
      t.integer :target_slope
      t.integer :target_aspect

      t.timestamps
    end
    add_index :transects, :transect_code, unique: true
    add_index :transects, :transect_name, unique: true
  end
end
