class Preference < ApplicationRecord
  belongs_to :user, optional: true
end