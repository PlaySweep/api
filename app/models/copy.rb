class Copy < ApplicationRecord
  belongs_to :copyable, polymorphic: true
end