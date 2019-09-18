class Sweep < ApplicationRecord
  belongs_to :user
  belongs_to :slate

  scope :ascending, -> { joins(:slate).merge(Slate.ascending) }
  scope :descending, -> { joins(:slate).merge(Slate.descending) }

  jsonb_accessor :data,
    pick_ids: [:string, array: true, default: []]

  after_create :set_data, :check_and_run_service

  def picks
    Pick.where(id: pick_ids)
  end

  def selections
    picks.map(&:selection)
  end

  private

  def set_data
    begin
      user.has_recently_won.set("1")
    rescue Redis::CannotConnectError => e
      puts e.inspect
    end
  end

  def check_and_run_service
    DrizlyService.new(user, slate).run(type: :sweep)
  end

  def add_entries!
    if user.referred_by_id?
      2.times { user.referred_by.entries.create(earned_by_id: user.id, reason: Entry::SWEEP) }
      NotifyReferrerJob.perform_later(user.referred_by_id, user.id, Entry::SWEEP)
    end
  end

end