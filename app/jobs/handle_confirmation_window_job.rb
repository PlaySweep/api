class HandleConfirmationWindowJob < ApplicationJob
  queue_as :high

  def perform resource_id, resource_type
    resource = resource_type.constantize.find_by(id: resource_id)
    SelectWinnerJob.perform_later(resource_id) unless slate.done?
  end
end