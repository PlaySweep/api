class Promotion < ApplicationRecord
  belongs_to :user, foreign_key: :used_by, optional: true
  belongs_to :slate, optional: true

  def value_in_format
    format("$%.0f", value)
  end
end