class Order < ApplicationRecord
  PENDING, PROCESSED, DELIVERED = 0, 1, 2
  belongs_to :user
  belongs_to :prize

  enum status: [ :pending, :processed, :delivered ]

  validates :prize_id, uniqueness: { scope: :user_id, message: "only 1 per user" }

  scope :for_yesterday, -> { where('created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day - 1) }

  around_save :catch_uniqueness_exception
  after_create :trigger_ticket_notification

  private

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:prize, :taken)
  end

  def trigger_ticket_notification
    if prize.product.category == "Tickets"
      text_message = "#{prize.product.name}\n\n#{user.full_name}\n#{user.email}\n#{user.line1} #{user.line2}\n#{user.city}, #{user.state} #{user.postal_code}"
      Popcorn.notify("9566265619", text_message)
    end
  end

end