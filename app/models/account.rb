class Account < ApplicationRecord
  has_many :messages, as: :messageable
  has_many :medias, as: :imageable
  has_many :images, as: :imageable
  has_many :copies, as: :copyable
  has_many :targets, class_name: "BroadcastTarget", as: :targetable
  has_many :links
  has_many :rewards, as: :rewardable
  has_many :users
end