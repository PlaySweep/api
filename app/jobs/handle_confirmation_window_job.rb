class HandleConfirmationWindowJob < BudweiserJob
  @queue = :handle_confirmation_window_job

  def perform slate_id
    slate = Slate.find_by(id: slate_id)
    SelectWinnerJob.perform_later(slate_id) unless slate.done?
  end
end