class Address < ApplicationRecord
  belongs_to :user

  store_accessor :data, :metadata
end