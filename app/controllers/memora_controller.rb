# frozen_string_literal: true

class MemoraController < ApplicationController
  before_action :set_agent
  before_action :set_memory_context
  
  def index
    # Main Memora terminal interface
    
    # Agent stats for the interface
    @agent_stats = {
      total_conversations: @agent.total_conversations,
      average_rating: @agent.average_rating.round(1),
      response_time: '< 2s',
      specializations: @agent.specializations
    }
  end
  
  def store_memory
    begin
      message = params[:message]
      
      if message.blank?
        render json: { 
          success: false, 
          message: "Please provide memory content to store" 
        }
        return
      end
      
      # Process memory storage request
      response = @memora_engine.process_input(
        current_user, 
        message, 
        memory_context_params.merge(request_type: :store_memory)
      )
      
      # Update session stats
      increment_session_stats('memories_stored')
      
      render json: {
        success: true,
        memory_response: response[:text],
        metadata: response[:metadata],
        memory_data: response[:memory_data],
        timestamp: response[:timestamp],
        processing_time: response[:processing_time]
      }
      
    rescue => e
      Rails.logger.error "Memora storage error: #{e.message}"
      render json: { 
        success: false, 
        message: "I encountered an issue storing your memory. Please try again with different content." 
      }
    end
  end
  
  def recall_memory
    begin
      query = params[:query] || params[:message]
      
      if query.blank?
        render json: { 
          success: false, 
          message: "Please provide a query to search your memories" 
        }
        return
      end
      
      # Process memory recall request
      response = @memora_engine.process_input(
        current_user, 
        query, 
        memory_context_params.merge(request_type: :recall_memory)
      )
      
      # Update session stats
      increment_session_stats('memories_recalled')
      
      render json: {
        success: true,
        recall_response: response[:text],
        metadata: response[:metadata],
        memory_data: response[:memory_data],
        timestamp: response[:timestamp],
        processing_time: response[:processing_time]
      }
      
    rescue => e
      Rails.logger.error "Memora recall error: #{e.message}"
      render json: { 
        success: false, 
        message: "I encountered an issue recalling your memories. Please try a different query." 
      }
    end
  end
  
  def search_memories
    begin
      search_query = params[:query]
      search_filters = {
        memory_type: params[:memory_type],
        priority: params[:priority],
        tags: params[:tags]&.split(','),
        date_range: params[:date_range]
      }
      
      response = @memora_engine.search_memories(
        current_user, 
        search_query, 
        memory_context_params.merge(filters: search_filters)
      )
      
      render json: {
        success: true,
        search_results: response,
        query: search_query,
        filters_applied: search_filters.compact
      }
      
    rescue => e
      Rails.logger.error "Memora search error: #{e.message}"
      render json: { 
        success: false, 
        message: "Search encountered an issue. Please try different search terms." 
      }
    end
  end
  
  def process_voice
    begin
      # Handle voice input processing
      audio_data = {
        sample_text: params[:transcription] || params[:message],
        confidence: params[:confidence] || 95,
        signature: params[:audio_signature]
      }
      
      response = @memora_engine.process_voice_input(
        current_user,
        audio_data,
        memory_context_params
      )
      
      increment_session_stats('voice_memories')
      
      render json: {
        success: true,
        voice_response: response,
        transcription: response[:transcription],
        memory_stored: response[:memory_stored]
      }
      
    rescue => e
      Rails.logger.error "Memora voice error: #{e.message}"
      render json: { 
        success: false, 
        message: "Voice processing encountered an issue. Please try again." 
      }
    end
  end
  
  def get_memory_stats
    begin
      stats = @memora_engine.get_memory_stats(current_user)
      
      render json: {
        success: true,
        stats: stats,
        session_stats: @session_data
      }
      
    rescue => e
      Rails.logger.error "Memora stats error: #{e.message}"
      render json: { 
        success: false, 
        message: "Unable to retrieve memory statistics." 
      }
    end
  end
  
  def get_memory_insights
    begin
      insights = @memora_engine.get_memory_insights(current_user)
      
      render json: {
        success: true,
        insights: insights,
        generated_at: Time.current
      }
      
    rescue => e
      Rails.logger.error "Memora insights error: #{e.message}"
      render json: { 
        success: false, 
        message: "Unable to generate memory insights." 
      }
    end
  end
  
  def export_memories
    begin
      export_format = params[:format] || 'json'
      export_filter = {
        memory_type: params[:memory_type],
        date_range: params[:date_range],
        priority: params[:priority]
      }
      
      exported_data = @memora_engine.export_memories(
        current_user, 
        export_format, 
        export_filter.compact
      )
      
      render json: {
        success: true,
        export_data: exported_data,
        format: export_format,
        filter_applied: export_filter.compact,
        download_url: "/memora/download/memories.#{export_format}"
      }
      
    rescue => e
      Rails.logger.error "Memora export error: #{e.message}"
      render json: { 
        success: false, 
        message: "Export process encountered an issue." 
      }
    end
  end
  
  def get_memory_types
    render json: {
      memory_types: Agents::MemoraEngine::MEMORY_TYPES,
      priority_levels: Agents::MemoraEngine::PRIORITY_LEVELS,
      context_tags: Agents::MemoraEngine::CONTEXT_TAGS
    }
  end
  
  def memory_graph
    begin
      # Get memory graph visualization data
      graph_data = generate_memory_graph_data(current_user)
      
      render json: {
        success: true,
        graph_data: graph_data,
        node_count: graph_data[:nodes]&.length || 0,
        connection_count: graph_data[:edges]&.length || 0
      }
      
    rescue => e
      Rails.logger.error "Memory graph error: #{e.message}"
      render json: { 
        success: false, 
        message: "Unable to generate memory graph." 
      }
    end
  end
  
  def terminal_command
    command = params[:command]
    args = params[:args] || []
    
    case command
    when 'stats'
      stats = @memora_engine.get_memory_stats(current_user)
      render json: { success: true, stats: stats }
    when 'types'
      render json: { 
        success: true, 
        types: Agents::MemoraEngine::MEMORY_TYPES 
      }
    when 'search'
      query = args.join(' ')
      if query.present?
        results = @memora_engine.recall_memory(current_user, query, {})
        render json: { success: true, results: results }
      else
        render json: { success: false, message: "Please provide search query" }
      end
    when 'insights'
      insights = @memora_engine.get_memory_insights(current_user)
      render json: { success: true, insights: insights }
    when 'export'
      format = args.first || 'json'
      export_data = @memora_engine.export_memories(current_user, format)
      render json: { success: true, export_data: export_data }
    when 'help'
      help_text = generate_memory_help_text
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
    @agent = Agent.find_by(agent_type: 'memora') || create_default_agent
    @memora_engine = @agent.engine_class.new(@agent)
  end
  
  def set_memory_context
    # @memory_stats = @memora_engine.get_memory_stats(current_user)
    @memory_stats = { total_memories: 0, avg_importance: 0, categories: [] } # Temporary placeholder
    @session_data = {
      memories_stored: session[:memora_stored] || 0,
      memories_recalled: session[:memora_recalled] || 0,
      voice_memories: session[:memora_voice] || 0,
      session_start: session[:memora_start] || Time.current,
      last_memory_type: session[:memora_last_type] || 'fact',
      active_integrations: session[:memora_integrations] || []
    }
  end
  
  def memory_context_params
    {
      memory_type: params[:memory_type],
      priority: params[:priority],
      tags: params[:tags]&.split(','),
      sync_agents: params[:sync_agents]&.split(','),
      agent: 'memora',
      mood: params[:current_mood] || 'neutral',
      platform: params[:platform] || 'terminal'
    }
  end
  
  def increment_session_stats(stat_key)
    session["memora_#{stat_key}"] = (session["memora_#{stat_key}"] || 0) + 1
    session[:memora_start] ||= Time.current
  end
  
  def create_default_agent
    Agent.create!(
      name: 'Memora',
      agent_type: 'memora',
      personality_traits: [
        'organized', 'reliable', 'analytical', 'contextual', 
        'intuitive', 'secure', 'adaptive', 'intelligent'
      ],
      capabilities: [
        'memory_storage', 'semantic_indexing', 'voice_processing',
        'context_binding', 'natural_recall', 'memory_graph',
        'privacy_protection', 'agent_synchronization'
      ],
      specializations: [
        'semantic_search', 'voice_recognition', 'context_analysis',
        'memory_patterns', 'knowledge_mapping', 'data_export',
        'privacy_encryption', 'cross_agent_sync'
      ],
      configuration: {
        'emoji' => '🧠',
        'tagline' => 'Your Intelligent Memory Manager - Capture, Store, Recall Everything',
        'primary_color' => '#6B46C1',
        'secondary_color' => '#8B5CF6',
        'response_style' => 'organized_intelligent'
      },
      status: 'active'
    )
  end
  
  def generate_memory_graph_data(user)
    # Generate mock graph data for visualization
    {
      nodes: [
        { id: 'goal_1', label: 'Career Goals', type: 'goal', size: 20 },
        { id: 'fact_1', label: 'Tech Knowledge', type: 'fact', size: 15 },
        { id: 'pref_1', label: 'Work Preferences', type: 'preference', size: 12 },
        { id: 'exp_1', label: 'Learning Experiences', type: 'experience', size: 18 }
      ],
      edges: [
        { from: 'goal_1', to: 'fact_1', weight: 0.8 },
        { from: 'goal_1', to: 'pref_1', weight: 0.6 },
        { from: 'fact_1', to: 'exp_1', weight: 0.7 }
      ],
      clusters: {
        work: ['goal_1', 'pref_1'],
        learning: ['fact_1', 'exp_1']
      }
    }
  end
  
  def generate_memory_help_text
    {
      commands: {
        'stats' => 'Show memory statistics and usage analytics',
        'types' => 'List all available memory types and categories',
        'search [query]' => 'Search memories using natural language',
        'insights' => 'Generate memory patterns and insights',
        'export [format]' => 'Export memories in specified format',
        'help' => 'Show this help message'
      },
      memory_types: Agents::MemoraEngine::MEMORY_TYPES.keys.map(&:to_s),
      examples: [
        "Remember: I prefer working in the morning with classical music #productivity",
        "Recall: What did I say about my career goals?",
        "Store goal: Launch my startup by December 2025 !high",
        "Voice: Remember my meeting notes from today"
      ],
      advanced_features: [
        "🗣️ Voice input with 'Voice: [content]' command",
        "🏷️ Use hashtags for automatic tagging",
        "🎯 Set priorities with !critical, !high, !medium, !low",
        "🔗 Agent sync with @emotisense, @cinegen, @contentcrafter",
        "🧠 Semantic search understands meaning, not just keywords",
        "📊 Memory graph shows connections between related memories"
      ]
    }
  end
end
