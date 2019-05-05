class StartSlateJob < BudweiserJob
  @queue = :start_slate_job

  def perform slate_id
    slate = Slate.find_by(id: slate_id)
    slate.started! and slate.class.inactive.ascending.first.pending! unless slate.nil? || slate.complete? || slate.done?
  end
end