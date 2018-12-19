class User < ApplicationRecord

  has_many :sweeps
  has_many :picks
  has_many :events, through: :picks
  has_many :cards
  has_many :slates, through: :cards

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def self.by_name full_name
    full_name = full_name.split(' ')
    find_by_first_name_and_last_name(full_name[0], full_name[-1])
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def playing_streak
    slate_dates = Slate.order("start_time DESC").pluck(:start_time).map(&:to_date)
    picked_dates = slates.order("start_time DESC").pluck(:start_time).map(&:to_date)
    streak = picked_dates.first == slate_dates.first ? 1 : 0
    picked_dates.each_with_index do |picked_date, index|
      if picked_dates[index+1] == slate_dates[index+1]
        streak += 1
      else
        break
      end
    end
    streak
  end

  def won_slate? slate_id
    slate = slates.find_by(id: slate_id)
    event_ids = events.where(slate_id: slate_id).map(&:id)
    picks_for_slate = picks.where(event_id: event_ids).map(&:selection_id)
    if picks_for_slate == slate.winner_ids
      return true
    else
      return false
    end
  end

end