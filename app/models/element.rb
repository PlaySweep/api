class Element < ApplicationRecord
  scope :saves, -> { where(name: "Save") }
end