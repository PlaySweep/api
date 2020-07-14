class Profile < ApplicationRecord
  belongs_to :owner
  belongs_to :team, foreign_key: :owner_id
  
  store_accessor :data, :era, :record
end