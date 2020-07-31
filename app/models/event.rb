class Event < ApplicationRecord
  include ActiveModel::Dirty

  INCOMPLETE, READY, COMPLETE, CLOSED = 0, 1, 2, 3

  belongs_to :slate
  has_many :cards, as: :cardable, through: :slate
  has_many :selections, dependent: :destroy
  has_many :picks, dependent: :destroy
  has_many :users, through: :picks

  accepts_nested_attributes_for :selections

  enum status: [ :incomplete, :ready, :complete, :closed ]

  after_update :update_picks

  scope :for_slate, ->(slate_id) { where(slate_id: slate_id) }
  scope :ordered, -> { order(order: :asc) }
  scope :most_recent, -> { order(order: :desc) }
  scope :descending, -> { joins(:slate).merge(Slate.descending) }
  scope :unfiltered, -> { joins(:slate).merge(Slate.unfiltered) }
  scope :incomplete, -> { where(status: INCOMPLETE) }
  scope :closed, -> { where(status: CLOSED) }

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

  def last?
    slate.events.ordered.last.id == id
  end

  def category_is_outcome?
    category == "Outcome"
  end

  private

  def update_picks
    CompletePicksJob.perform_later(id) if saved_change_to_status?(from: 'ready', to: 'complete') and winner_ids.any?
  end

  # def revert_picks
  #   picks.map(&:pending!) if saved_change_to_status?(from: 'closed', to: 'incomplete')
  # end

end