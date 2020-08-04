class StartSlateJob < ApplicationJob
  include ActiveJob::Status
  queue_as :critical

  def perform slate_id
    queued_job = BackgroundJob.queued.find_by(resource_id: slate_id)
    queued_status = ActiveJob::Status.get(queued_job.job_id)
    queued_job.performed!
    return if queued_status[:cancelled]
    slate = Slate.find_by(id: slate_id)
    slate.started! if slate.pending?
    if slate.owner_id?
      slate.owner.slates.inactive.ascending.first.pending! if slate.owner.slates.inactive.ascending.first
    else
      inactive_global_slates = Slate.unfiltered.ascending.inactive
      inactive_global_slates.first.pending! if inactive_global_slates.first
    end
  end
end