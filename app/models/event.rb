class Event < ApplicationRecord
  INCOMPLETE, COMPLETE = 0, 1

  belongs_to :slate
  has_many :cards, through: :slate
  has_many :selections, dependent: :destroy
  has_many :picks, dependent: :destroy
  has_many :users, through: :picks

  accepts_nested_attributes_for :selections

  jsonb_accessor :data,
    winner_ids: [:integer, array: true, default: []]

  enum status: [ :incomplete, :complete ]

  after_update :result_event, :result_card

  scope :for_slate, ->(slate_id) { where(slate_id: slate_id) }
  scope :ordered, -> { order(order: :asc) }

  def loser_ids
    selections.map(&:id) - winner_ids
  end

  def winners
    selections.find_by(id: winner_ids)
  end

  def losers
    selections.find_by(id: loser_ids) if winner_ids
  end

  private

  def result_event
    if saved_change_to_status?(to: 'complete') and winner_ids.any?
      picks.where(selection_id: winner_ids).map(&:win!)
      picks.where(selection_id: loser_ids).map(&:loss!)
    end
  end

  def result_card
    if saved_change_to_status?(to: 'complete') && slate.events.ordered.last.id == id
     cards.each do |card|
      if card.user.won_slate?(slate.id)
        card.win!
      else
        card.loss!
      end
     end
    end
  end

end