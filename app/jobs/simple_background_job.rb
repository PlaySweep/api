class SimpleBackgroundJob < ApplicationJob
  queue_as :low

  def perform(klass, job_id, resource, resource_id)
    BackgroundJob.create(job_name: klass, job_id: job_id, resource: resource, resource_id: resource_id)
  end
end