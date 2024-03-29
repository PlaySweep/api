class HandleConfirmationWindowJob < ApplicationJob
  queue_as :high

  def perform resource_id, resource_type
    resource = resource_type.constantize.find_by(id: resource_id)
    if resource_type == "Slate"
      SelectWinnerJob.perform_later(resource_id) unless resource.done?
    end
    if resource_type == "Quiz"
      SelectWinnerJob.perform_later(resource_id) unless resource.complete?
    end
  end
end