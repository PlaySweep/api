require 'connection_pool'

Redis.current = Redis.new(url: ENV["REDIS_URL"])
Redis::Objects.redis = ConnectionPool.new(size: 10, timeout: 5) { Redis.new(url: ENV["REDIS_URL"]) }