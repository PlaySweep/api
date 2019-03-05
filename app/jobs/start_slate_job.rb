class StartSlateJob < BudweiserJob
  @queue = :start_slate_job

  # before_perform do |job|
  #   puts "job => #{job.inspect}"
  #   slate = BudweiserSlate.find_by(id: job.arguments.first)
  #   puts "Kill job if set back to inactive or #{slate} was deleted"
  # end

  def perform slate_id
    slate = BudweiserSlate.find_by(id: slate_id)
    slate.started! if slate
  end
end