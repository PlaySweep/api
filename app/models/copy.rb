class Copy < ApplicationRecord
  belongs_to :copyable, polymorphic: true

  scope :active, -> { where(active: true) }
end