require 'popcorn'

Popcorn.configure do |config|
  config.api_key = ENV["POPCORNNOTIFY_API_KEY"]
end