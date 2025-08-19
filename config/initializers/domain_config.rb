# OneLastAI Domain Configuration
# Configure domain-specific settings for onelastai.com

Rails.application.configure do
  # Domain configuration
  domain_config = {
    production: {
      primary_domain: 'onelastai.com',
      www_domain: 'www.onelastai.com',
      api_domain: 'api.onelastai.com',
      cdn_domain: 'cdn.onelastai.com',
      subdomains: %w[
        neochat emotisense cinegen contentcrafter memora netscope
        aiblogster authwise callghost carebot codemaster datasphere
        datavision dnaforge documind dreamweaver girlfriend ideaforge
        infoseek labx personax quintexa virtualspace worldforge
        configai features admin api
      ]
    },
    development: {
      primary_domain: 'localhost:3000',
      www_domain: 'localhost:3000',
      api_domain: 'localhost:3000',
      cdn_domain: 'localhost:3000',
      subdomains: []
    }
  }

  current_config = domain_config[Rails.env.to_sym] || domain_config[:development]

  # Set configuration for current environment
  config.primary_domain = current_config[:primary_domain]
  config.www_domain = current_config[:www_domain]
  config.api_domain = current_config[:api_domain]
  config.cdn_domain = current_config[:cdn_domain]
  config.agent_subdomains = current_config[:subdomains]

  # Configure Action Cable for WebSocket connections
  if Rails.env.production?
    config.action_cable.url = "wss://#{current_config[:primary_domain]}/cable"
    config.action_cable.allowed_request_origins = [
      "https://#{current_config[:primary_domain]}",
      "https://#{current_config[:www_domain]}"
    ] + current_config[:subdomains].map { |sub| "https://#{sub}.#{current_config[:primary_domain]}" }
  end

  # Configure asset host for CDN
  if Rails.env.production? && ENV['CDN_URL'].present?
    config.asset_host = ENV['CDN_URL']
  end

  # Configure email domain
  config.action_mailer.default_url_options = {
    host: current_config[:primary_domain],
    protocol: Rails.env.production? ? 'https' : 'http'
  }

  # Configure default from email
  config.action_mailer.default_options = {
    from: "noreply@#{Rails.env.production? ? 'onelastai.com' : 'localhost'}"
  }
end

# Helper methods for domain configuration
module DomainHelper
  def self.agent_subdomain_url(agent_name, path = '/')
    domain = Rails.env.production? ? 'onelastai.com' : 'localhost:3000'
    protocol = Rails.env.production? ? 'https' : 'http'
    "#{protocol}://#{agent_name}.#{domain}#{path}"
  end

  def self.api_url(endpoint = '')
    domain = Rails.env.production? ? 'api.onelastai.com' : 'localhost:3000/api'
    protocol = Rails.env.production? ? 'https' : 'http'
    "#{protocol}://#{domain}#{endpoint}"
  end

  def self.primary_url(path = '/')
    domain = Rails.env.production? ? 'onelastai.com' : 'localhost:3000'
    protocol = Rails.env.production? ? 'https' : 'http'
    "#{protocol}://#{domain}#{path}"
  end
end

# Make domain helper available globally
Rails.application.config.domain_helper = DomainHelper
