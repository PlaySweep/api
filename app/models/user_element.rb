class UserElement < ApplicationRecord
  belongs_to :user
  belongs_to :element
  belongs_to :used_for, foreign_key: :used_for_id, optional: true
  belongs_to :used_on, foreign_key: :used_on_id, optional: true

  scope :used, -> { where(used: true) }
  scope :unused, -> { where(used: false) }
  scope :for_saves, -> { joins(:element).merge(Element.saves) }

end