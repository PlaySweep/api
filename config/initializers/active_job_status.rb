ActiveJob::Status.store = :redis_store
ActiveJob::Status.options = { expires_in: 14.days.to_i }