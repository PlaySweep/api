ActiveJob::Status.store = :redis_store
ActiveJob::Status.options = { expires_in: 30.days.to_i }