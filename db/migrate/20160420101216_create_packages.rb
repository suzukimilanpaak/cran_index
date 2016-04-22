class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name, limit: 150
      t.integer :current_description_id
      t.string :current_version, limit: 20

      t.timestamps null: false
    end
  end
end
