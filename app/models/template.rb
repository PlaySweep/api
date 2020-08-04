class Template < ApplicationRecord
  belongs_to :owner
  has_many :items

  scope :active, -> { where(active: true) }
  scope :filtered, ->(owner_id) { where(owner_id: owner_id) }
end