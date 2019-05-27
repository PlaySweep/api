class League < Account
  has_many :medias, as: :imageable
end