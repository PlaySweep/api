class Sweep < ApplicationRecord
  belongs_to :user

  jsonb_accessor :data,
    pick_ids: [:string, array: true, default: []]

  def picks
    Pick.where(id: pick_ids)
  end
end