# Add to Gemfile for production deployment

# Environment configuration
gem 'dotenv-rails', groups: [:development, :test]

# AI API clients
gem 'ruby-openai', '~> 6.3'
gem 'anthropic', '~> 0.1'
gem 'google-cloud-ai_platform', '~> 1.0'
gem 'hugging-face', '~> 0.3'

# HTTP client for API calls
gem 'faraday', '~> 2.7'
gem 'faraday-retry', '~> 2.2'
gem 'faraday-net_http_persistent', '~> 2.1'

# Background jobs
gem 'sidekiq', '~> 7.2'
gem 'sidekiq-web'

# Caching and Redis
gem 'redis', '~> 5.0'
gem 'hiredis', '~> 0.6'

# Database
gem 'pg', '~> 1.5', platforms: :ruby

# Monitoring and logging
gem 'sentry-ruby', '~> 5.14'
gem 'sentry-rails', '~> 5.14'
gem 'newrelic_rpm', '~> 9.5'

# File uploads and storage
gem 'aws-sdk-s3', '~> 1.136'
gem 'image_processing', '~> 1.12'

# Security
gem 'rack-cors', '~> 2.0'
gem 'rack-attack', '~> 6.7'

# API
gem 'jsonapi-serializer', '~> 2.2'
gem 'jwt', '~> 2.7'

# Performance
gem 'bootsnap', '>= 1.16', require: false
gem 'multi_json', '~> 1.15'

# Development and test tools
group :development, :test do
  gem 'rspec-rails', '~> 6.0'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.2'
  gem 'vcr', '~> 6.2'
  gem 'webmock', '~> 3.19'
end

group :development do
  gem 'listen', '~> 3.8'
  gem 'spring', '~> 4.1'
  gem 'spring-watcher-listen', '~> 2.1'
  gem 'annotate', '~> 3.2'
end

# Production optimizations
group :production do
  gem 'lograge', '~> 0.14'
  gem 'rack-timeout', '~> 0.6'
end