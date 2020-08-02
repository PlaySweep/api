class UserElement < ApplicationRecord
  belongs_to :user
  belongs_to :element
  belongs_to :used_for, foreign_key: :used_for_id, optional: true
  belongs_to :used_on, foreign_key: :used_on_id, optional: true

  scope :used, -> { where(used: true) }
  scope :unused, -> { where(used: false) }

  scope :for_entries, -> { joins(:element).merge(Element.with_entries) }
  scope :for_erasers, -> { joins(:element).merge(Element.erasers) }

end