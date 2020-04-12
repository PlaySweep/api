class Sweep < ApplicationRecord
  belongs_to :user
  belongs_to :sweepable, polymorphic: true

  store_accessor :data, :pick_ids

  after_create :run_services, :add_elements

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
    OwnerService.new(user, slate: sweepable).run(type: :sweep)
    ContestService.new(user, slate: sweepable).run(type: :sweep)
    DrizlyService.new(user, sweepable).run(type: :sweep)
  end

  def add_elements
    user.elements.create(element_id: 1)
  end

end