class Owner < ApplicationRecord
  resourcify 
  
  belongs_to :account 
  has_many :slates
  has_many :images, as: :imageable
  has_many :messages, as: :messageable
  has_many :medias, as: :imageable
  has_many :rewards, as: :rewardable
  has_many :targets, class_name: "BroadcastTarget", as: :targetable
end