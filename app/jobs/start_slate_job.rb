class StartSlateJob < BudweiserJob
  @queue = :start_slate_job

  def perform slate_id
    slate = Slate.find_by(id: slate_id)
    slate.started! unless slate.nil? || slate.complete? || slate.done?
    slate.team.slates.inactive.ascending.first.pending! if slate.team.slates.inactive.ascending.first
  end
end