class BudweiserSlate < Slate
  belongs_to :team, foreign_key: :owner_id

  after_update :result_slate
  after_update :change_status

  scope :for_owner, ->(owner_id) { where(owner_id: owner_id) } 

  jsonb_accessor :data,
      local: [:boolean, default: false],
      opponent_id: [:integer, default: nil],
      field: [:string, default: nil],
      opponent_pitcher: [:string, default: nil],
      pitcher: [:string, default: nil],
      era: [:string, default: nil],
      opponent_era: [:string, default: nil],
      prizing_category: [:string, default: nil]

  private

  def result_slate
    send_winning_message and send_losing_message if saved_change_to_status?(to: 'complete') and events_are_completed?
  end

  def change_status
    StartSlateJob.set(wait_until: start_time).perform_later(id) if saved_change_to_status?(to: 'pending')
  end

  def send_winning_message
    #TODO create a sweep record
    cards.win.each do |card|
      SendWinningSlateMessageJob.perform_later(card.user_id)
      card.user.sweeps.create(date: DateTime.current, pick_ids: card.user.picks.for_slate(id).map(&:id))
    end
  end

  def send_losing_message
    cards.loss.each { |card| SendLosingSlateMessageJob.perform_later(card.user_id)}
  end

end