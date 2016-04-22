class CreateCommitters < ActiveRecord::Migration
  def change
    create_table :committers do |t|
      t.string :name
      t.string :email
      t.string :type, limit: 50

      t.timestamps null: false
    end
  end
end
