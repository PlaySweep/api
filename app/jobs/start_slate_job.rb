class StartSlateJob < BudweiserJob
  @queue = :start_slate_job

  def perform slate_id
    slate = Slate.find_by(id: slate_id)
    next_slate = slate.class.filtered(slate.owner_id).inactive.ascending.first
    slate.started! unless slate.nil? || slate.complete? || slate.done?
    next_slate.pending! if next_slate
  end
end