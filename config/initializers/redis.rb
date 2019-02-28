require 'connection_pool'

if Rails.env == 'production'
  uri = URI.parse(ENV["REDIS_URL"])
  Redis.current = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(:host => uri.host, :port => uri.port, :password => uri.password) }
else
  Redis.current = Redis.new(:host => 'localhost', :port => 6379)
  Resque.redis = Redis.new(:host => 'localhost', :port => 6379)
  Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(:host => 'localhost', :port => 6379) }
end