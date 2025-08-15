# Secure Headers Configuration for OneLastAI
# This file configures security headers to protect against common web vulnerabilities

SecureHeaders::Configuration.default do |config|
  # Content Security Policy (CSP)
  # Allow our application to function while maintaining security
  config.csp = {
    # Allow unsafe-inline for styles due to Tailwind CSS and inline styles
    default_src: ["'self'"],
    script_src: ["'self'", "'unsafe-inline'", "'unsafe-eval'", 'data:', 'blob:'],
    style_src: ["'self'", "'unsafe-inline'", 'fonts.googleapis.com'],
    font_src: ["'self'", 'fonts.gstatic.com'],
    img_src: ["'self'", 'data:', 'blob:', 'https:'],
    connect_src: ["'self'", 'ws:', 'wss:', 'https:'],
    frame_src: ["'self'"],
    object_src: ["'none'"],
    base_uri: ["'self'"],
    form_action: ["'self'"],
    frame_ancestors: ["'none'"],
    manifest_src: ["'self'"],
    media_src: ["'self'", 'blob:', 'data:'],
    worker_src: ["'self'", 'blob:'],
    # Allow Rails development features
    upgrade_insecure_requests: Rails.env.production?
  }

  # HTTP Strict Transport Security (HSTS)
  # Force HTTPS connections in production
  config.hsts = if Rails.env.production?
                  {
                    max_age: 31_536_000, # 1 year
                    include_subdomains: true,
                    preload: true
                  }
                else
                  # Disable HSTS in development
                  SecureHeaders::OPT_OUT
                end

  # X-Frame-Options
  # Prevent clickjacking attacks
  config.x_frame_options = 'DENY'

  # X-Content-Type-Options
  # Prevent MIME type sniffing
  config.x_content_type_options = 'nosniff'

  # X-XSS-Protection
  # Enable XSS protection in browsers
  config.x_xss_protection = '1; mode=block'

  # Referrer Policy
  # Control how much referrer information is included with requests
  config.referrer_policy = 'strict-origin-when-cross-origin'
end

# Development-specific overrides
if Rails.env.development?
  SecureHeaders::Configuration.named_append(:development) do |config|
    # More permissive CSP for development with live reload and debugging tools
    config.csp[:script_src] += ['localhost:*', '127.0.0.1:*', "'unsafe-eval'"]
    config.csp[:connect_src] += ['localhost:*', '127.0.0.1:*', 'ws://localhost:*', 'ws://127.0.0.1:*']
    config.csp[:style_src] += ["'unsafe-inline'"]
  end
end

# Log configuration status
Rails.logger.info "SecureHeaders configured for #{Rails.env} environment" if Rails.env.development?
