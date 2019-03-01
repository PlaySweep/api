require 'connection_pool'

if Rails.env == 'production'
  Redis.current = Redis.new(:host => ENV["REDIS_URL"], :port => 6379)
  Resque.redis = Redis.new(:host => ENV["REDIS_URL"], :port => 6379)
  Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(:host => ENV["REDIS_URL"], :port => 6379) }
else
  Redis.current = Redis.new(:host => 'localhost', :port => 6379)
  Resque.redis = Redis.new(:host => 'localhost', :port => 6379)
  Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(:host => 'localhost', :port => 6379) }
end