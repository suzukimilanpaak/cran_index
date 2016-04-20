class Package < ActiveRecord::Base
  has_many :descriptions
  belongs_to :current_description,
    class_name: 'Description',
    foreign_key: 'current_description_id'
end
