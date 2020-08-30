class Sweep < ApplicationRecord
  belongs_to :user
  belongs_to :sweepable, polymorphic: true

  store_accessor :data, :pick_ids

  after_create :run_services

  def picks
    Pick.where(id: pick_ids)
  end

  def slate_selections
    picks.map(&:selection)
  end

  def quiz_answers
    choices.map(&:answer)
  end

  private

  def run_services
    OwnerService.new(user: user, slate: sweepable).run(type: :sweep)
    ContestService.new(user: user, contest: sweepable.contest).run(type: :sweep)
    AccountService.new(user: user).run(type: :sweep)
  end

end