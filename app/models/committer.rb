class Committer < ActiveRecord::Base
  has_and_belongs_to_many :descriptions, association_foreign_key: 'description_id'
end
