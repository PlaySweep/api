class PhoneNumber < ApplicationRecord
  belongs_to :user, optional: true
end