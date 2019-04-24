class Card < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2
  belongs_to :user
  belongs_to :slate

  enum status: [ :pending, :win, :loss ]

  scope :for_slate, ->(slate_id) { where(slate_id: slate_id) } 

  after_create :send_slate_notification

  private

  def send_slate_notification
    SendSlateNotificationJob.perform_later(user_id)
  end

end