class StartSlateJob < ApplicationJob
  @queue = :start_slate_job

  def perform slate_id
    slate = Slate.find_by(id: slate_id)
    slate.started! unless slate.nil? || slate.complete? || slate.done?
    if slate.global?
      inactive_global_slates = Slate.unfiltered.ascending.inactive
      inactive_global_slates.first.pending! if inactive_global_slates.first
    else
      slate.team.slates.inactive.ascending.first.pending! if slate.team.slates.inactive.ascending.first
    end
  end
end