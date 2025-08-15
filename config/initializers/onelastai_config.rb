# OneLastAI Configuration Initializer
# This file loads and validates the application configuration

require_relative '../application_config'

# Validate configuration in production
if Rails.env.production?
  OneLastAI::Configuration.validate!
end

# Set up Redis configuration
if OneLastAI::Configuration.config.redis_url.present?
  $redis = Redis.new(url: OneLastAI::Configuration.config.redis_url)
end

# Configure Sentry for error monitoring
if OneLastAI::Configuration.config.sentry_dsn.present?
  Sentry.configure do |config|
    config.dsn = OneLastAI::Configuration.config.sentry_dsn
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]
    config.environment = Rails.env
    config.release = OneLastAI::Configuration.config.app_version
  end
end

# Log configuration status
Rails.logger.info "OneLastAI Configuration loaded for #{Rails.env} environment"
Rails.logger.info "OpenAI API: #{OneLastAI::Configuration.ai_api_configured?(:openai) ? 'Configured' : 'Not configured'}"
Rails.logger.info "Anthropic API: #{OneLastAI::Configuration.ai_api_configured?(:anthropic) ? 'Configured' : 'Not configured'}"
Rails.logger.info "Google AI API: #{OneLastAI::Configuration.ai_api_configured?(:google) ? 'Configured' : 'Not configured'}"
Rails.logger.info "Redis: #{OneLastAI::Configuration.config.redis_url.present? ? 'Configured' : 'Not configured'}"