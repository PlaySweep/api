class HandleConfirmationWindowJob < ApplicationJob
  queue_as :high

  def perform slate_id
    slate = Slate.find_by(id: slate_id)
    SelectWinnerJob.perform_later(slate_id) unless slate.done?
  end
end