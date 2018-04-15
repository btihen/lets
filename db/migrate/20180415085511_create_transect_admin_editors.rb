class CreateTransectAdminEditors < ActiveRecord::Migration[5.2]
  def change
    create_table :transect_admin_editors do |t|
      t.references :transect, foreign_key: true
      t.references :admin,    foreign_key: true

      t.timestamps
    end
    add_index :transect_admin_editors, [:transect_id, :admin_id], unique: true
  end
end
