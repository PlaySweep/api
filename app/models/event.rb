class Event < ApplicationRecord
  INCOMPLETE, COMPLETE = 0, 1

  belongs_to :slate
  has_many :cards, through: :slate
  has_many :selections, dependent: :destroy
  has_many :picks, dependent: :destroy
  has_many :users, through: :picks

  accepts_nested_attributes_for :selections

  enum status: [ :incomplete, :complete ]

  after_update :update_picks

  scope :for_slate, ->(slate_id) { where(slate_id: slate_id) }
  scope :ordered, -> { order(order: :asc) }
  scope :most_recent, -> { order(order: :desc) }
  scope :descending, -> { joins(:slate).merge(Slate.descending) }
  scope :unfiltered, -> { joins(:slate).merge(Slate.unfiltered) }

  store_accessor :data, :category

  def winner_ids
    selections.winners.map(&:id)
  end

  def loser_ids
    selections.losers.map(&:id)
  end

  def winners
    selections.winners
  end

  def losers
    selections.losers
  end

  private

  def update_picks
    if saved_change_to_status?(from: 'incomplete', to: 'complete') and winner_ids.any?
      picks.where(selection_id: winner_ids).map(&:win!)
      picks.where(selection_id: loser_ids).map(&:loss!)
    elsif saved_change_to_status?(from: 'complete', to: 'incomplete')
      picks.map(&:pending!)
    end
  end

end