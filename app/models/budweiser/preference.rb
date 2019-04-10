class Preference < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :team, foreign_key: :owner_id, optional: true

  jsonb_accessor :data,
      owner_id: [:integer, default: nil],
      slate_messaging: [:boolean, default: true]
end