# Passage Authentication Service (1Password Powered)
class PassageAuthService
  include HTTParty
  
  base_uri 'https://auth.passage.id/v1'
  
  def initialize
    @app_id = ENV['PASSAGE_APP_ID']
    @api_key = ENV['PASSAGE_API_KEY']
    
    validate_configuration!
  end

  # Authenticate user with Passage
  def authenticate(token)
    response = self.class.get("/apps/#{@app_id}/userinfo", {
      headers: {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      }
    })
    
    handle_response(response)
  end

  # Create new user registration
  def register_user(email, user_metadata = {})
    payload = {
      email: email,
      user_metadata: user_metadata
    }
    
    response = self.class.post("/apps/#{@app_id}/users", {
      headers: auth_headers,
      body: payload.to_json
    })
    
    handle_response(response)
  end

  # Initiate WebAuthn registration
  def start_webauthn_registration(user_id)
    response = self.class.post("/apps/#{@app_id}/users/#{user_id}/webauthn/register/start", {
      headers: auth_headers
    })
    
    handle_response(response)
  end

  # Complete WebAuthn registration
  def finish_webauthn_registration(user_id, credential_data)
    payload = {
      handshake_id: credential_data[:handshake_id],
      handshake_response: credential_data[:handshake_response]
    }
    
    response = self.class.post("/apps/#{@app_id}/users/#{user_id}/webauthn/register/finish", {
      headers: auth_headers,
      body: payload.to_json
    })
    
    handle_response(response)
  end

  # Start passwordless login
  def start_passwordless_login(email)
    payload = { email: email }
    
    response = self.class.post("/apps/#{@app_id}/login/magic-link", {
      headers: auth_headers,
      body: payload.to_json
    })
    
    handle_response(response)
  end

  # Verify magic link token
  def verify_magic_link(token)
    payload = { magic_link_token: token }
    
    response = self.class.post("/apps/#{@app_id}/login/magic-link/verify", {
      headers: auth_headers,
      body: payload.to_json
    })
    
    handle_response(response)
  end

  # Get user profile
  def get_user(user_id)
    response = self.class.get("/apps/#{@app_id}/users/#{user_id}", {
      headers: auth_headers
    })
    
    handle_response(response)
  end

  # Update user metadata
  def update_user(user_id, user_metadata)
    payload = { user_metadata: user_metadata }
    
    response = self.class.patch("/apps/#{@app_id}/users/#{user_id}", {
      headers: auth_headers,
      body: payload.to_json
    })
    
    handle_response(response)
  end

  # Revoke user session
  def revoke_session(user_id)
    response = self.class.delete("/apps/#{@app_id}/users/#{user_id}/sessions", {
      headers: auth_headers
    })
    
    response.code == 200
  end

  # List user devices
  def list_user_devices(user_id)
    response = self.class.get("/apps/#{@app_id}/users/#{user_id}/devices", {
      headers: auth_headers
    })
    
    handle_response(response)
  end

  # Revoke user device
  def revoke_device(user_id, device_id)
    response = self.class.delete("/apps/#{@app_id}/users/#{user_id}/devices/#{device_id}", {
      headers: auth_headers
    })
    
    response.code == 200
  end

  private

  def validate_configuration!
    raise ConfigurationError, "PASSAGE_APP_ID is required" if @app_id.blank?
    raise ConfigurationError, "PASSAGE_API_KEY is required" if @api_key.blank?
  end

  def auth_headers
    {
      'Authorization' => "Bearer #{@api_key}",
      'Content-Type' => 'application/json'
    }
  end

  def handle_response(response)
    case response.code
    when 200..299
      JSON.parse(response.body)
    when 401
      raise AuthenticationError, "Invalid Passage API credentials"
    when 404
      raise NotFoundError, "Resource not found"
    when 422
      error_details = JSON.parse(response.body)
      raise ValidationError, error_details['message']
    else
      raise APIError, "Passage API error: #{response.code} - #{response.body}"
    end
  rescue JSON::ParserError
    raise APIError, "Invalid JSON response from Passage API"
  end

  # Custom exception classes
  class PassageError < StandardError; end
  class ConfigurationError < PassageError; end
  class AuthenticationError < PassageError; end
  class NotFoundError < PassageError; end
  class ValidationError < PassageError; end
  class APIError < PassageError; end
end

# 1Password Integration Service
class OnePasswordService
  include HTTParty
  
  base_uri 'https://my.1password.com/api/v1'
  
  def initialize
    @service_account_token = ENV['ONEPASSWORD_SERVICE_ACCOUNT_TOKEN']
    @vault_id = ENV['ONEPASSWORD_VAULT_ID']
    
    validate_configuration!
  end

  # Store secret in 1Password
  def store_secret(title, fields = {})
    payload = {
      title: title,
      vault: { id: @vault_id },
      category: 'LOGIN',
      fields: format_fields(fields)
    }
    
    response = self.class.post('/items', {
      headers: auth_headers,
      body: payload.to_json
    })
    
    handle_response(response)
  end

  # Retrieve secret from 1Password
  def get_secret(item_id)
    response = self.class.get("/items/#{item_id}", {
      headers: auth_headers
    })
    
    handle_response(response)
  end

  # Update secret in 1Password
  def update_secret(item_id, fields = {})
    payload = {
      fields: format_fields(fields)
    }
    
    response = self.class.patch("/items/#{item_id}", {
      headers: auth_headers,
      body: payload.to_json
    })
    
    handle_response(response)
  end

  # Delete secret from 1Password
  def delete_secret(item_id)
    response = self.class.delete("/items/#{item_id}", {
      headers: auth_headers
    })
    
    response.code == 204
  end

  # List all items in vault
  def list_secrets
    response = self.class.get("/vaults/#{@vault_id}/items", {
      headers: auth_headers
    })
    
    handle_response(response)
  end

  # Generate secure password
  def generate_password(length: 32, include_symbols: true)
    payload = {
      length: length,
      include_symbols: include_symbols
    }
    
    response = self.class.post('/generate-password', {
      headers: auth_headers,
      body: payload.to_json
    })
    
    handle_response(response)
  end

  private

  def validate_configuration!
    raise ConfigurationError, "ONEPASSWORD_SERVICE_ACCOUNT_TOKEN is required" if @service_account_token.blank?
    raise ConfigurationError, "ONEPASSWORD_VAULT_ID is required" if @vault_id.blank?
  end

  def auth_headers
    {
      'Authorization' => "Bearer #{@service_account_token}",
      'Content-Type' => 'application/json'
    }
  end

  def format_fields(fields)
    fields.map do |key, value|
      {
        id: SecureRandom.uuid,
        type: 'STRING',
        purpose: key.to_s.upcase,
        label: key.to_s.humanize,
        value: value.to_s
      }
    end
  end

  def handle_response(response)
    case response.code
    when 200..299
      JSON.parse(response.body)
    when 401
      raise AuthenticationError, "Invalid 1Password service account token"
    when 403
      raise AuthorizationError, "Insufficient permissions for 1Password vault"
    when 404
      raise NotFoundError, "1Password item not found"
    else
      raise APIError, "1Password API error: #{response.code} - #{response.body}"
    end
  rescue JSON::ParserError
    raise APIError, "Invalid JSON response from 1Password API"
  end

  # Custom exception classes
  class OnePasswordError < StandardError; end
  class ConfigurationError < OnePasswordError; end
  class AuthenticationError < OnePasswordError; end
  class AuthorizationError < OnePasswordError; end
  class NotFoundError < OnePasswordError; end
  class APIError < OnePasswordError; end
end
