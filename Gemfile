source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
gem 'redis-objects'
gem 'redis-rails', '~> 5'
gem 'connection_pool'
gem 'sidekiq'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'popcorn_notify'

gem 'rb-readline'

gem 'rufus-scheduler'

gem 'geocoder'
gem 'haversine'

gem 'leaderboard'

gem 'simple_service_object'
gem 'friendly_id', '~> 5.2.4'

gem 'possessive'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

gem 'activerecord-typedstore'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'responders'

gem 'rolify'

gem "jsonb_accessor", "~> 1.0.0"
gem 'faraday'
gem 'hash_dot'
gem 'json'
gem 'facebook-messenger'

gem 'apartment'
gem 'apartment-activejob'

gem 'staccato'
gem "appsignal"

gem 'rails-erd', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Deployment
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.3", require: false
  gem 'capistrano-rvm'
  gem 'capistrano-bundler', '~> 1.3'
  gem 'capistrano-passenger'
  gem 'capistrano-nc', '~> 0.2'
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rake', require: false
  gem 'capistrano-sidekiq'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
