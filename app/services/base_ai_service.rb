# Base AI Service for OneLastAI
# All AI agents inherit from this class for consistent API integration

require 'httparty'
require 'net/http'
require 'uri'
require 'json'

class BaseAiService
  include HTTParty
  
  attr_reader :agent_name, :model, :api_key, :timeout
  
  # =============================================================================
  # INITIALIZATION
  # =============================================================================
  
  def initialize(agent_name:, options: {})
    @agent_name = agent_name
    @model = options[:model] || OneLastAI::Configuration.agent_model_for(agent_name)
    @timeout = options[:timeout] || OneLastAI::Configuration.config.agent_timeout_default
    @max_retries = options[:max_retries] || 3
    @rate_limit_tier = options[:tier] || :free
    
    setup_api_client
  end
  
  # =============================================================================
  # PUBLIC API METHODS
  # =============================================================================
  
  def chat(message, context: {})
    validate_rate_limit!
    
    begin
      response = make_api_request(message, context)
      process_response(response)
    rescue => e
      handle_error(e)
    end
  end
  
  def stream_chat(message, context: {}, &block)
    validate_rate_limit!
    
    begin
      stream_api_request(message, context, &block)
    rescue => e
      handle_error(e)
    end
  end
  
  def generate_content(prompt, type: :text, options: {})
    validate_rate_limit!
    
    case type
    when :text
      generate_text(prompt, options)
    when :image
      generate_image(prompt, options)
    when :audio
      generate_audio(prompt, options)
    when :video
      generate_video(prompt, options)
    else
      raise ArgumentError, "Unsupported content type: #{type}"
    end
  end
  
  # =============================================================================
  # API CLIENT SETUP
  # =============================================================================
  
  private
  
  def setup_api_client
    case primary_api_provider
    when :openai
      setup_openai_client
    when :anthropic
      setup_anthropic_client
    when :google
      setup_google_client
    when :huggingface
      setup_huggingface_client
    when :cohere
      setup_cohere_client
    else
      raise "No AI API provider configured for #{@agent_name}"
    end
  end
  
  def primary_api_provider
    # Determine primary API based on agent type and availability
    case @agent_name.to_s
    when 'emotisense', 'memora'
      return :anthropic if OneLastAI::Configuration.ai_api_configured?(:anthropic)
    when 'cinegen', 'ideaforge'
      return :openai if OneLastAI::Configuration.ai_api_configured?(:openai)
    when 'datavision', 'netscope'
      return :google if OneLastAI::Configuration.ai_api_configured?(:google)
    end
    
    # Fallback to first available API
    [:openai, :anthropic, :google, :huggingface, :cohere].each do |provider|
      return provider if OneLastAI::Configuration.ai_api_configured?(provider)
    end
    
    nil
  end
  
  # =============================================================================
  # API CLIENT CONFIGURATIONS
  # =============================================================================
  
  def setup_openai_client
    @api_key = OneLastAI::Configuration.config.openai_api_key
    @base_url = 'https://api.openai.com/v1'
    @headers = {
      'Authorization' => "Bearer #{@api_key}",
      'Content-Type' => 'application/json',
      'OpenAI-Organization' => OneLastAI::Configuration.config.openai_organization_id
    }.compact
  end
  
  def setup_anthropic_client
    @api_key = OneLastAI::Configuration.config.anthropic_api_key
    @base_url = 'https://api.anthropic.com/v1'
    @headers = {
      'x-api-key' => @api_key,
      'Content-Type' => 'application/json',
      'anthropic-version' => '2023-06-01'
    }
  end
  
  def setup_google_client
    @api_key = OneLastAI::Configuration.config.google_ai_api_key
    @base_url = 'https://generativelanguage.googleapis.com/v1beta'
    @headers = {
      'Content-Type' => 'application/json'
    }
  end
  
  def setup_huggingface_client
    @api_key = OneLastAI::Configuration.config.huggingface_api_key
    @base_url = 'https://api-inference.huggingface.co/models'
    @headers = {
      'Authorization' => "Bearer #{@api_key}",
      'Content-Type' => 'application/json'
    }
  end
  
  def setup_cohere_client
    @api_key = OneLastAI::Configuration.config.cohere_api_key
    @base_url = 'https://api.cohere.ai/v1'
    @headers = {
      'Authorization' => "Bearer #{@api_key}",
      'Content-Type' => 'application/json'
    }
  end
  
  # =============================================================================
  # API REQUEST METHODS
  # =============================================================================
  
  def make_api_request(message, context = {})
    payload = build_request_payload(message, context)
    endpoint = get_api_endpoint
    
    Rails.logger.info "AI Request for #{@agent_name}: #{endpoint}"
    
    response = HTTParty.post(
      "#{@base_url}/#{endpoint}",
      body: payload.to_json,
      headers: @headers,
      timeout: @timeout
    )
    
    log_api_usage(message, response)
    validate_response!(response)
    
    response
  end
  
  def stream_api_request(message, context = {}, &block)
    payload = build_request_payload(message, context, stream: true)
    endpoint = get_api_endpoint
    
    Rails.logger.info "AI Stream Request for #{@agent_name}: #{endpoint}"
    
    uri = URI("#{@base_url}/#{endpoint}")
    
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Post.new(uri)
      @headers.each { |key, value| request[key] = value }
      request.body = payload.to_json
      
      http.request(request) do |response|
        response.read_body do |chunk|
          process_stream_chunk(chunk, &block)
        end
      end
    end
  end
  
  # =============================================================================
  # CONTENT GENERATION METHODS
  # =============================================================================
  
  def generate_text(prompt, options = {})
    make_api_request(prompt, options.merge(type: :text))
  end
  
  def generate_image(prompt, options = {})
    case primary_api_provider
    when :openai
      generate_openai_image(prompt, options)
    when :stability
      generate_stability_image(prompt, options)
    else
      raise "Image generation not supported for current provider"
    end
  end
  
  def generate_audio(prompt, options = {})
    case options[:type]
    when :speech
      generate_speech(prompt, options)
    when :transcription
      transcribe_audio(prompt, options)
    else
      raise "Audio type not specified or supported"
    end
  end
  
  def generate_video(prompt, options = {})
    if OneLastAI::Configuration.config.runwayml_api_key.present?
      generate_runwayml_video(prompt, options)
    else
      raise "Video generation requires RunwayML API key"
    end
  end
  
  # =============================================================================
  # RESPONSE PROCESSING
  # =============================================================================
  
  def process_response(response)
    case primary_api_provider
    when :openai
      process_openai_response(response)
    when :anthropic
      process_anthropic_response(response)
    when :google
      process_google_response(response)
    when :huggingface
      process_huggingface_response(response)
    when :cohere
      process_cohere_response(response)
    end
  end
  
  def process_openai_response(response)
    data = JSON.parse(response.body)
    content = data.dig('choices', 0, 'message', 'content')
    
    {
      content: content,
      model: data['model'],
      usage: data['usage'],
      provider: :openai,
      raw_response: data
    }
  end
  
  def process_anthropic_response(response)
    data = JSON.parse(response.body)
    content = data.dig('content', 0, 'text')
    
    {
      content: content,
      model: data['model'],
      usage: data['usage'],
      provider: :anthropic,
      raw_response: data
    }
  end
  
  def process_google_response(response)
    data = JSON.parse(response.body)
    content = data.dig('candidates', 0, 'content', 'parts', 0, 'text')
    
    {
      content: content,
      model: @model,
      provider: :google,
      raw_response: data
    }
  end
  
  def process_huggingface_response(response)
    data = JSON.parse(response.body)
    content = data.is_a?(Array) ? data.first['generated_text'] : data['generated_text']
    
    {
      content: content,
      model: @model,
      provider: :huggingface,
      raw_response: data
    }
  end
  
  def process_cohere_response(response)
    data = JSON.parse(response.body)
    content = data['generations']&.first&.dig('text')
    
    {
      content: content,
      model: data['meta']&.dig('api_version', 'version'),
      provider: :cohere,
      raw_response: data
    }
  end
  
  # =============================================================================
  # REQUEST PAYLOAD BUILDERS
  # =============================================================================
  
  def build_request_payload(message, context = {}, stream: false)
    case primary_api_provider
    when :openai
      build_openai_payload(message, context, stream)
    when :anthropic
      build_anthropic_payload(message, context, stream)
    when :google
      build_google_payload(message, context)
    when :huggingface
      build_huggingface_payload(message, context)
    when :cohere
      build_cohere_payload(message, context, stream)
    end
  end
  
  def build_openai_payload(message, context, stream = false)
    {
      model: @model,
      messages: build_message_history(message, context),
      max_tokens: OneLastAI::Configuration.config.openai_max_tokens,
      temperature: OneLastAI::Configuration.config.openai_temperature,
      stream: stream
    }
  end
  
  def build_anthropic_payload(message, context, stream = false)
    {
      model: @model,
      max_tokens: OneLastAI::Configuration.config.anthropic_max_tokens,
      messages: build_message_history(message, context),
      stream: stream
    }
  end
  
  def build_google_payload(message, context)
    {
      contents: [{
        parts: [{ text: message }]
      }],
      generationConfig: {
        maxOutputTokens: 4000,
        temperature: 0.7
      }
    }
  end
  
  def build_huggingface_payload(message, context)
    {
      inputs: message,
      parameters: {
        max_new_tokens: 1000,
        temperature: 0.7,
        return_full_text: false
      }
    }
  end
  
  def build_cohere_payload(message, context, stream = false)
    {
      model: @model,
      message: message,
      max_tokens: 1000,
      temperature: 0.7,
      stream: stream
    }
  end
  
  # =============================================================================
  # UTILITY METHODS
  # =============================================================================
  
  def build_message_history(message, context)
    messages = []
    
    # Add system prompt if provided
    if context[:system_prompt]
      messages << { role: 'system', content: context[:system_prompt] }
    end
    
    # Add conversation history if provided
    if context[:history].is_a?(Array)
      messages.concat(context[:history])
    end
    
    # Add current message
    messages << { role: 'user', content: message }
    
    messages
  end
  
  def get_api_endpoint
    case primary_api_provider
    when :openai
      'chat/completions'
    when :anthropic
      'messages'
    when :google
      "models/#{@model}:generateContent?key=#{@api_key}"
    when :huggingface
      @model
    when :cohere
      'chat'
    end
  end
  
  def validate_response!(response)
    unless response.success?
      error_message = "API request failed: #{response.code} - #{response.body}"
      Rails.logger.error error_message
      raise StandardError, error_message
    end
  end
  
  def validate_rate_limit!
    # Implementation would check Redis for rate limiting
    # For now, just log the request
    Rails.logger.debug "Rate limit check for #{@agent_name} (tier: #{@rate_limit_tier})"
  end
  
  def log_api_usage(message, response)
    Rails.logger.info "AI API Usage - Agent: #{@agent_name}, Provider: #{primary_api_provider}, " \
                      "Status: #{response.code}, Input length: #{message.length}"
  end
  
  def handle_error(error)
    Rails.logger.error "AI Service Error for #{@agent_name}: #{error.message}"
    
    {
      content: "I'm sorry, but I'm experiencing technical difficulties right now. Please try again in a moment.",
      error: error.message,
      provider: primary_api_provider,
      success: false
    }
  end
  
  def process_stream_chunk(chunk, &block)
    # Process server-sent events for streaming responses
    chunk.split("\n").each do |line|
      next unless line.start_with?('data: ')
      
      data = line[6..-1]
      next if data == '[DONE]'
      
      begin
        parsed_data = JSON.parse(data)
        content = extract_stream_content(parsed_data)
        block.call(content) if content && block_given?
      rescue JSON::ParserError
        # Skip invalid JSON chunks
        next
      end
    end
  end
  
  def extract_stream_content(data)
    case primary_api_provider
    when :openai
      data.dig('choices', 0, 'delta', 'content')
    when :anthropic
      data.dig('delta', 'text')
    when :cohere
      data.dig('text')
    end
  end
end