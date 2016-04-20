class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name, limit: 150
      t.string :current_description_id

      t.timestamps null: false
    end
  end
end
