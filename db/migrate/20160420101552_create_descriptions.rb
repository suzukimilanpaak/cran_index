class CreateDescriptions < ActiveRecord::Migration
  def change
    create_table :descriptions do |t|
      t.integer :package_id
      t.string :version
      t.string :title
      t.text :description
      t.datetime :published_at

      t.timestamps null: false
    end
  end
end
