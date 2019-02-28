if Rails.env == 'production'
  Resque.redis = ENV['REDIS_URL']
else
  Resque.redis = 'localhost:6379'
end