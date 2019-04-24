class Sweep < ApplicationRecord
  belongs_to :user
  belongs_to :slate

  jsonb_accessor :data,
    pick_ids: [:string, array: true, default: []]

  def picks
    Pick.where(id: pick_ids)
  end

  def selections
    picks.map(&:selection)
  end
end