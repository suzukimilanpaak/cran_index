class Description < ActiveRecord::Base
  belongs_to :package
  has_and_belongs_to_many :authors, association_foreign_key: 'committer_id'
  has_and_belongs_to_many :maintainers, association_foreign_key: 'committer_id'
end
