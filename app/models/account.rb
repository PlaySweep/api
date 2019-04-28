class Account < ApplicationRecord
  has_many :messages, as: :messageable
end