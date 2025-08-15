# frozen_string_literal: true

class ContentcrafterController < ApplicationController
  before_action :set_agent
  before_action :set_content_context
  
  def index
    # Main ContentCrafter terminal interface
    
    # Agent stats for the interface
    @agent_stats = {
      total_conversations: @agent.total_conversations,
      average_rating: @agent.average_rating.round(1),
      response_time: '< 2s',
      specializations: @agent.specializations
    }
  end
  
  def generate_content
    begin
      message = params[:message]
      
      if message.blank?
        render json: { 
          success: false, 
          message: "Please provide content requirements" 
        }
        return
      end
      
      # Process content generation request
      response = @contentcrafter_engine.process_input(
        current_user, 
        message, 
        content_context_params
      )
      
      render json: {
        success: true,
        content_response: response[:text],
        metadata: response[:metadata],
        content_data: response[:content_data],
        timestamp: response[:timestamp],
        processing_time: response[:processing_time]
      }
      
    rescue => e
      Rails.logger.error "ContentCrafter error: #{e.message}"
      render json: { 
        success: false, 
        message: "I encountered an issue generating content. Please try again with different requirements." 
      }
    end
  end
  
  def get_content_formats
    render json: {
      formats: Agents::ContentcrafterEngine::CONTENT_FORMATS,
      tones: Agents::ContentcrafterEngine::TONE_STYLES,
      audiences: Agents::ContentcrafterEngine::AUDIENCE_TYPES
    }
  end
  
  def preview_content
    format_type = params[:format]&.to_sym || :blog_post
    demo_content = @contentcrafter_engine.get_demo_content(format_type)
    
    render json: {
      success: true,
      demo_content: demo_content,
      format: format_type
    }
  end
  
  def export_content
    content_id = params[:content_id]
    export_format = params[:format] || 'markdown'
    
    # In a real app, you'd retrieve the content from database
    # For demo, we'll generate sample content
    sample_content = generate_sample_export_content(export_format)
    
    render json: {
      success: true,
      exported_content: sample_content,
      format: export_format,
      download_url: "/contentcrafter/download/#{content_id}.#{export_format}"
    }
  end
  
  def analyze_content
    content_text = params[:content]
    
    if content_text.blank?
      render json: { 
        success: false, 
        message: "Please provide content to analyze" 
      }
      return
    end
    
    analysis = {
      word_count: content_text.split.length,
      reading_time: "#{(content_text.split.length / 200.0).ceil} min read",
      sentences: content_text.split(/[.!?]/).length,
      paragraphs: content_text.split(/\n\s*\n/).length,
      emotional_tone: analyze_emotional_tone(content_text),
      complexity: calculate_complexity_score(content_text),
      suggestions: generate_content_suggestions(content_text)
    }
    
    render json: {
      success: true,
      analysis: analysis
    }
  end
  
  def fusion_generate
    # Generate content with agent fusion capabilities
    fusion_request = {
      primary_agent: 'contentcrafter',
      fusion_agents: params[:fusion_agents] || ['emotisense'],
      content_type: params[:content_type] || 'blog_post',
      emotional_context: params[:emotional_context],
      visual_requirements: params[:visual_requirements]
    }
    
    response = @contentcrafter_engine.generate_content(
      fusion_request.merge(content_context_params),
      current_user
    )
    
    render json: {
      success: true,
      fusion_content: response[:content],
      metadata: response[:metadata],
      fusion_data: {
        emotional_analysis: fusion_request[:emotional_context],
        visual_suggestions: response[:content][:multimedia],
        agent_contributions: {
          contentcrafter: "Core content generation",
          emotisense: "Emotional tone analysis",
          cinegen: "Visual composition suggestions"
        }
      }
    }
  end
  
  def terminal_command
    command = params[:command]
    args = params[:args] || []
    
    case command
    when 'stats'
      stats = @contentcrafter_engine.get_content_stats
      render json: { success: true, stats: stats }
    when 'formats'
      render json: { 
        success: true, 
        formats: Agents::ContentcrafterEngine::CONTENT_FORMATS 
      }
    when 'demo'
      format_type = args.first&.to_sym || :blog_post
      demo = @contentcrafter_engine.get_demo_content(format_type)
      render json: { success: true, demo: demo }
    when 'help'
      help_text = generate_help_text
      render json: { success: true, help: help_text }
    else
      render json: { 
        success: false, 
        message: "Unknown command: #{command}. Type 'help' for available commands." 
      }
    end
  end
  
  private
  
  def set_agent
    @agent = Agent.find_by(agent_type: 'contentcrafter') || create_default_agent
    @contentcrafter_engine = @agent.engine_class.new(@agent)
  end
  
  def set_content_context
    @content_stats = @contentcrafter_engine.get_content_stats
    @session_data = {
      formats_used: session[:contentcrafter_formats] || [],
      content_generated: session[:contentcrafter_count] || 0,
      session_start: session[:contentcrafter_start] || Time.current,
      last_format: session[:contentcrafter_last_format] || 'blog_post'
    }
  end
  
  def content_context_params
    {
      format: params[:format],
      tone: params[:tone],
      audience: params[:audience],
      length: params[:length],
      include_multimedia: params[:include_multimedia] == 'true',
      platform: params[:platform] || 'web'
    }
  end
  
  def create_default_agent
    Agent.create!(
      name: 'ContentCrafter',
      agent_type: 'contentcrafter',
      personality_traits: [
        'creative', 'analytical', 'adaptable', 'detail_oriented', 
        'strategic', 'versatile', 'professional', 'innovative'
      ],
      capabilities: [
        'content_generation', 'format_adaptation', 'tone_control',
        'audience_targeting', 'multimedia_integration', 'export_management'
      ],
      specializations: [
        'blog_writing', 'copywriting', 'technical_writing', 'creative_writing',
        'social_media', 'email_marketing', 'script_writing', 'agent_fusion'
      ],
      configuration: {
        'emoji' => '📝',
        'tagline' => 'Your AI Content Creator - From Blog Posts to Cinematic Scripts',
        'primary_color' => '#007acc',
        'secondary_color' => '#0066aa',
        'response_style' => 'professional_creative'
      },
      status: 'active'
    )
  end
  
  def analyze_emotional_tone(text)
    positive_indicators = ['excellent', 'amazing', 'wonderful', 'great', 'fantastic', 'brilliant']
    negative_indicators = ['difficult', 'challenging', 'problem', 'issue', 'concern', 'struggle']
    neutral_indicators = ['analyze', 'consider', 'examine', 'review', 'evaluate']
    
    text_lower = text.downcase
    
    positive_count = positive_indicators.count { |word| text_lower.include?(word) }
    negative_count = negative_indicators.count { |word| text_lower.include?(word) }
    neutral_count = neutral_indicators.count { |word| text_lower.include?(word) }
    
    if positive_count > negative_count && positive_count > neutral_count
      'Positive & Engaging'
    elsif negative_count > positive_count
      'Cautious & Analytical'
    else
      'Neutral & Informative'
    end
  end
  
  def calculate_complexity_score(text)
    words = text.split.length
    sentences = text.split(/[.!?]/).length
    
    return 'Low' if sentences == 0
    
    avg_words_per_sentence = words.to_f / sentences
    
    case avg_words_per_sentence
    when 0..10
      'Low'
    when 11..20
      'Medium'
    else
      'High'
    end
  end
  
  def generate_content_suggestions(text)
    suggestions = []
    words = text.split.length
    
    suggestions << "Consider adding subheadings to break up long sections" if words > 500
    suggestions << "Add more descriptive examples to illustrate key points" if words < 200
    suggestions << "Include a clear call-to-action at the end" unless text.downcase.include?('contact') || text.downcase.include?('learn more')
    suggestions << "Consider adding bullet points for better readability" unless text.include?('•') || text.include?('-')
    suggestions << "Add emotional appeal to connect with readers" unless analyze_emotional_tone(text) == 'Positive & Engaging'
    
    suggestions.empty? ? ["Content looks great! Consider A/B testing different headlines."] : suggestions
  end
  
  def generate_sample_export_content(format)
    case format
    when 'markdown'
      "# Sample Content\n\nThis is a **sample** exported content in Markdown format.\n\n## Key Features\n\n- Clean formatting\n- Easy to read\n- Web-ready\n\n*Generated by ContentCrafter*"
    when 'html'
      "<h1>Sample Content</h1><p>This is a <strong>sample</strong> exported content in HTML format.</p><h2>Key Features</h2><ul><li>Clean formatting</li><li>Easy to read</li><li>Web-ready</li></ul><p><em>Generated by ContentCrafter</em></p>"
    when 'json'
      {
        title: "Sample Content",
        content: "This is a sample exported content in JSON format.",
        features: ["Clean formatting", "Easy to read", "Web-ready"],
        metadata: { generator: "ContentCrafter", timestamp: Time.current }
      }.to_json
    else
      "Sample Content\n\nThis is a sample exported content in plain text format.\n\nKey Features:\n- Clean formatting\n- Easy to read\n- Web-ready\n\nGenerated by ContentCrafter"
    end
  end
  
  def generate_help_text
    {
      commands: {
        'stats' => 'Show ContentCrafter statistics and capabilities',
        'formats' => 'List all available content formats',
        'demo [format]' => 'Generate demo content for specified format',
        'help' => 'Show this help message'
      },
      examples: [
        "Create a blog post about AI in friendly tone for general audience",
        "Generate ad copy for productivity app targeting business professionals",
        "Write agent intro for EmotiSense in empathetic tone",
        "Create script about innovation in inspiring tone"
      ],
      fusion_capabilities: [
        "Emotional analysis integration with EmotiSense",
        "Visual suggestions from CineGen",
        "Multi-format content adaptation",
        "Real-time content optimization"
      ]
    }
  end
end
