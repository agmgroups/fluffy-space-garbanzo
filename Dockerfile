# OneLastAI Production Dockerfile
FROM ruby:3.4.0-alpine

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    sqlite-dev \
    nodejs \
    npm \
    git \
    tzdata \
    imagemagick \
    curl \
    bash

# Set working directory
WORKDIR /app

# Install bundler
RUN gem install bundler -v 2.4.10

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Precompile assets
RUN RAILS_ENV=production \
    SECRET_KEY_BASE=dummy \
    bundle exec rails assets:precompile

# Create non-root user
RUN addgroup -g 1001 -S appuser && \
    adduser -S appuser -u 1001 -G appuser

# Create necessary directories
RUN mkdir -p /app/log /app/tmp /app/storage && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port (default); Railway will set PORT env at runtime
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Start command (Puma reads PORT from environment via config/puma.rb)
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]