class HealthController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def show
    checks = {
      database: check_database,
      redis: check_redis,
      storage: check_storage,
      ai_apis: check_ai_apis
    }
    
    status = checks.values.all? ? 'healthy' : 'unhealthy'
    http_status = status == 'healthy' ? 200 : 503
    
    render json: {
      status: status,
      timestamp: Time.current.iso8601,
      version: OneLastAI::Configuration.config.app_version,
      environment: Rails.env,
      checks: checks
    }, status: http_status
  end
  
  def ready
    if ready_to_serve?
      render json: { 
        status: 'ready',
        timestamp: Time.current.iso8601
      }
    else
      render json: { 
        status: 'not ready',
        timestamp: Time.current.iso8601
      }, status: 503
    end
  end
  
  private
  
  def check_database
    Mongoid.client(:default).database.command({ ping: 1 })
    true
  rescue => e
    Rails.logger.error "Database health check failed: #{e.message}"
    false
  end
  
  def check_redis
    return true unless OneLastAI::Configuration.config.redis_url.present?
    
    $redis&.ping == 'PONG'
  rescue => e
    Rails.logger.error "Redis health check failed: #{e.message}"
    false
  end
  
  def check_storage
    # Basic storage check - in production you might want to check S3 connectivity
    Dir.exist?(Rails.root.join('storage'))
  rescue => e
    Rails.logger.error "Storage health check failed: #{e.message}"
    false
  end
  
  def check_ai_apis
    # Check if at least one AI API is configured
    OneLastAI::Configuration.ai_api_configured?(:openai) ||
    OneLastAI::Configuration.ai_api_configured?(:anthropic) ||
    OneLastAI::Configuration.ai_api_configured?(:google) ||
    OneLastAI::Configuration.ai_api_configured?(:huggingface) ||
    OneLastAI::Configuration.ai_api_configured?(:cohere)
  end
  
  def ready_to_serve?
    check_database && check_redis
  end
end