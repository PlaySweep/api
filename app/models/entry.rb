class Entry < ApplicationRecord
  belongs_to :user

  scope :unused, -> { where(used: false) }
end