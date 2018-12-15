class Event < ApplicationRecord
  INCOMPLETE, COMPLETE = 0, 1

  belongs_to :slate
  has_many :selections, dependent: :destroy
  has_many :picks, dependent: :destroy
  has_many :users, through: :picks

  accepts_nested_attributes_for :selections

  jsonb_accessor :data,
    winner_ids: [:integer, array: true, default: []]

  enum status: [ :incomplete, :complete ]

  scope :for_slate, ->(slate_id) { where(slate_id: slate_id) }
  scope :ordered, -> { order(order: :asc) }

  def loser_ids
    selections.map(&:id) - winner_ids
  end

  # When all events are complete, make an update to the complete the slate

end