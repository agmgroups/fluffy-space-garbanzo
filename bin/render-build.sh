#!/bin/bash

# Render build script
set -o errexit

echo "🔥 Building Rails app for Render..."

# Install dependencies
bundle install

# Precompile assets (if using asset pipeline)
bundle exec rails assets:precompile RAILS_ENV=production

# Create MongoDB indexes (if needed)
# bundle exec rails db:mongoid:create_indexes RAILS_ENV=production

echo "✅ Build complete!"
