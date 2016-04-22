class CreateCommittersDescriptions < ActiveRecord::Migration
  def change
    create_table :committers_descriptions do |t|
      t.integer :committer_id
      t.integer :description_id

      t.timestamps null: false

      t.index [:description_id, :committer_id]
    end
  end
end
