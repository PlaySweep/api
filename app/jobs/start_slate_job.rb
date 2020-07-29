class StartSlateJob < ApplicationJob
  queue_as :critical

  def perform slate_id
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