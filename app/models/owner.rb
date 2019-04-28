class Owner < ApplicationRecord
  belongs_to :account 
  has_many :slates
  has_many :messages, as: :messageable
  has_many :targets, class_name: "BroadcastTarget", as: :targetable
end