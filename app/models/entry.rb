class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :slate, optional: true

  scope :unused, -> { where(used: false) }
end