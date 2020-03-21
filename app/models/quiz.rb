class Quiz < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :cards, as: :cardable, dependent: :destroy
  has_many :prizes, as: :prizeable, dependent: :destroy

  enum status: [ :inactive, :pending, :started, :complete, :done ]

  scope :filtered, ->(role_ids) { where(owner_id: role_ids).or(Quiz.where(owner_id: nil)) }
  scope :available, -> { where(status: [1, 2]) }
  scope :finished, -> { where(status: [3, 4]) }
  scope :ascending, -> { order(start_time: :asc) }
  scope :descending, -> { order(start_time: :desc) } 

  def owner
    return Owner.find_by(id: owner_id)
    Owner.find_by(id: team_id)
  end

  def team
    return Team.find_by(id: owner_id)
    Team.find_by(id: team_id)
  end

  def prize
    return prizes.first if prizes.any?
  end

  def played? current_user_id
    cards.find_by(user_id: current_user_id, cardable_id: id).present?
  end

end