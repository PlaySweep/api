class Pick < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2

  after_create :send_slate_notification

  belongs_to :event
  belongs_to :user
  belongs_to :selection

  enum status: [ :pending, :win, :loss ]


  scope :for_slate, ->(slate_id) { joins(:event).where('events.slate_id = ?', slate_id) }

  def current_slate
    event.slate
  end

  def send_slate_notification
    if event.slate.progress(user_id) == :complete
      SendSlateNotificationJob.perform_later(user_id)
    end
  end

end