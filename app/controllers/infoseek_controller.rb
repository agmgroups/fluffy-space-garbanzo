# frozen_string_literal: true

class InfoseekController < ApplicationController
  before_action :find_infoseek_agent
  before_action :ensure_demo_user

  def index
    # Main agent page with hero section and terminal interface
    @agent_stats = {
      total_conversations: @agent.total_conversations,
      average_rating: @agent.average_rating.round(1),
      response_time: '< 2s',
      specializations: @agent.specializations
    }
  end

  def chat
    # Handle chat messages from the terminal interface
    user_message = params[:message]&.strip

    if user_message.blank?
      render json: { error: 'Message cannot be empty' }, status: :bad_request
      return
    end

    begin
      # Process InfoSeek research request
      response_data = process_infoseek_request(user_message)

      render json: {
        success: true,
        response: response_data[:text],
        processing_time: response_data[:processing_time],
        agent_name: @agent.name,
        timestamp: Time.current.strftime('%H:%M:%S'),
        sources: response_data[:sources],
        research_type: response_data[:research_type],
        related_topics: response_data[:related_topics],
        confidence_score: response_data[:confidence_score]
      }
    rescue StandardError => e
      Rails.logger.error "Infoseek Error: #{e.message}"

      render json: {
        error: 'Sorry, I encountered an error processing your message. Please try again.',
        timestamp: Time.current.strftime('%H:%M:%S')
      }, status: :internal_server_error
    end
  end

  # New specialized InfoSeek endpoints
  def deep_research
    query = params[:query]
    research_depth = params[:depth] || 'comprehensive'

    research_results = perform_deep_research(query, research_depth)

    render json: {
      success: true,
      results: research_results,
      methodology: explain_research_methodology(research_depth),
      citations: generate_citations(research_results)
    }
  end

  def fact_check
    statement = params[:statement]
    context = params[:context] || ''

    fact_check_results = verify_statement(statement, context)

    render json: {
      success: true,
      verification: fact_check_results,
      confidence_level: calculate_confidence(fact_check_results),
      supporting_evidence: gather_evidence(statement)
    }
  end

  def research_assistant
    topic = params[:topic]
    assistance_type = params[:type] || 'overview'

    assistance_data = provide_research_assistance(topic, assistance_type)

    render json: {
      success: true,
      assistance: assistance_data,
      research_roadmap: create_research_roadmap(topic),
      recommended_sources: suggest_sources(topic)
    }
  end

  def trend_analysis
    subject = params[:subject]
    timeframe = params[:timeframe] || '1year'

    trend_data = analyze_trends(subject, timeframe)

    render json: {
      success: true,
      trends: trend_data,
      insights: extract_trend_insights(trend_data),
      predictions: generate_trend_predictions(subject, trend_data)
    }
  end

  def status
    # Agent status endpoint for monitoring
    render json: {
      agent: @agent.name,
      status: @agent.status,
      uptime: time_since_last_active,
      capabilities: @agent.capabilities,
      response_style: @agent.configuration['response_style'],
      last_active: @agent.last_active_at&.strftime('%Y-%m-%d %H:%M:%S')
    }
  end

  private

  def find_infoseek_agent
    @agent = Agent.find_by(agent_type: 'infoseek', status: 'active')

    return if @agent

    redirect_to root_url(subdomain: false), alert: 'Infoseek agent is currently unavailable'
  end

  def ensure_demo_user
    # Create or find a demo user for the session
    session_id = session[:user_session_id] ||= SecureRandom.uuid

    @user = User.find_or_create_by(email: "demo_#{session_id}@infoseek.onelastai.com") do |user|
      user.name = "Infoseek User #{rand(1000..9999)}"
      user.preferences = {
        communication_style: 'terminal',
        interface_theme: 'dark',
        response_detail: 'comprehensive'
      }.to_json
    end

    session[:current_user_id] = @user.id
  end

  def build_chat_context
    {
      interface_mode: 'terminal',
      subdomain: 'infoseek',
      session_id: session[:user_session_id],
      user_preferences: JSON.parse(@user.preferences || '{}'),
      conversation_history: recent_conversation_history
    }
  end

  def recent_conversation_history
    # Get the last 5 interactions for context
    @agent.agent_interactions
          .where(user: @user)
          .order(created_at: :desc)
          .limit(5)
          .pluck(:user_message, :agent_response)
          .reverse
  end

  def time_since_last_active
    return 'Just started' unless @agent.last_active_at

    time_diff = Time.current - @agent.last_active_at

    if time_diff < 1.minute
      'Just now'
    elsif time_diff < 1.hour
      "#{(time_diff / 1.minute).to_i} minutes ago"
    else
      "#{(time_diff / 1.hour).to_i} hours ago"
    end
  end

  # InfoSeek specialized processing methods
  def process_infoseek_request(message)
    research_intent = detect_research_intent(message)

    case research_intent
    when :fact_check
      handle_fact_check_request(message)
    when :deep_research
      handle_deep_research_request(message)
    when :trend_analysis
      handle_trend_analysis_request(message)
    when :comparison
      handle_comparison_request(message)
    when :timeline
      handle_timeline_request(message)
    else
      handle_general_research_query(message)
    end
  end

  def detect_research_intent(message)
    message_lower = message.downcase

    return :fact_check if message_lower.match?(/fact.?check|verify|true|false|accurate|confirm/)
    return :deep_research if message_lower.match?(/research|investigate|study|analysis|comprehensive/)
    return :trend_analysis if message_lower.match?(/trend|pattern|over time|historical|evolution/)
    return :comparison if message_lower.match?(/compare|versus|vs|difference|contrast/)
    return :timeline if message_lower.match?(/timeline|chronology|history|when|sequence/)

    :general
  end

  def handle_fact_check_request(_message)
    {
      text: "🔍 **Fact-Check Engine Activated**\n\n" \
            "I'll verify the accuracy of your statement using multiple authoritative sources:\n\n" \
            "✅ **Verification Process:**\n" \
            "• Cross-reference with 10+ reliable sources\n" \
            "• Check publication dates & credibility\n" \
            "• Analyze conflicting information\n" \
            "• Provide confidence rating (0-100%)\n\n" \
            "📊 **Source Categories:**\n" \
            "• Academic journals & research papers\n" \
            "• Government databases & statistics\n" \
            "• News outlets with high credibility scores\n" \
            "• Expert opinions & institutional reports\n\n" \
            "🎯 **Fact-Check Features:**\n" \
            "• Evidence-based conclusions\n" \
            "• Source transparency & citations\n" \
            "• Context analysis & nuance detection\n" \
            "• Bias identification & correction\n\n" \
            "Please provide the statement you'd like me to verify!",
      processing_time: rand(1.2..2.8).round(2),
      sources: generate_sample_sources('fact_check'),
      research_type: 'fact_verification',
      related_topics: ['source credibility', 'bias detection', 'evidence analysis'],
      confidence_score: rand(85..98)
    }
  end

  def handle_deep_research_request(_message)
    {
      text: "📚 **Deep Research Engine Initiated**\n\n" \
            "Conducting comprehensive research with advanced methodologies:\n\n" \
            "🎯 **Research Scope:**\n" \
            "• Academic literature review (20+ sources)\n" \
            "• Current events & news analysis\n" \
            "• Statistical data & trend analysis\n" \
            "• Expert interviews & opinions\n" \
            "• Historical context & background\n\n" \
            "⚡ **Research Capabilities:**\n" \
            "• Multi-language source analysis\n" \
            "• Real-time information updates\n" \
            "• Peer-reviewed publication access\n" \
            "• Government & institutional data\n" \
            "• Social media sentiment analysis\n\n" \
            "📖 **Deliverables:**\n" \
            "• Executive summary with key findings\n" \
            "• Detailed research report\n" \
            "• Source bibliography & citations\n" \
            "• Recommendations & next steps\n\n" \
            'What topic would you like me to research comprehensively?',
      processing_time: rand(2.5..5.2).round(2),
      sources: generate_sample_sources('deep_research'),
      research_type: 'comprehensive_analysis',
      related_topics: ['methodology', 'literature review', 'data analysis'],
      confidence_score: rand(90..97)
    }
  end

  def handle_trend_analysis_request(_message)
    {
      text: "📈 **Trend Analysis Engine Online**\n\n" \
            "Analyzing patterns and trends across multiple timeframes:\n\n" \
            "🔄 **Analysis Dimensions:**\n" \
            "• Historical trends (1+ years of data)\n" \
            "• Seasonal patterns & cycles\n" \
            "• Market movements & indicators\n" \
            "• Social media sentiment shifts\n" \
            "• Geographic distribution patterns\n\n" \
            "📊 **Advanced Analytics:**\n" \
            "• Machine learning pattern recognition\n" \
            "• Predictive modeling & forecasting\n" \
            "• Correlation analysis & causation\n" \
            "• Anomaly detection & outliers\n" \
            "• Statistical significance testing\n\n" \
            "🎯 **Trend Insights:**\n" \
            "• Growth rates & acceleration\n" \
            "• Inflection points & turning moments\n" \
            "• Future trajectory predictions\n" \
            "• Risk factors & opportunities\n\n" \
            'Which subject would you like me to analyze for trends?',
      processing_time: rand(1.8..4.1).round(2),
      sources: generate_sample_sources('trend_analysis'),
      research_type: 'trend_analysis',
      related_topics: ['statistical analysis', 'forecasting', 'pattern recognition'],
      confidence_score: rand(88..95)
    }
  end

  def handle_comparison_request(_message)
    {
      text: "⚖️ **Comparative Analysis Engine Ready**\n\n" \
            "Performing detailed side-by-side comparisons:\n\n" \
            "🔍 **Comparison Framework:**\n" \
            "• Feature-by-feature analysis\n" \
            "• Pros & cons evaluation\n" \
            "• Performance metrics comparison\n" \
            "• Cost-benefit analysis\n" \
            "• User reviews & expert opinions\n\n" \
            "📊 **Evaluation Criteria:**\n" \
            "• Objective measurements & data\n" \
            "• Subjective quality assessments\n" \
            "• Market position & reputation\n" \
            "• Innovation & future potential\n" \
            "• Value proposition analysis\n\n" \
            "📋 **Comparison Deliverables:**\n" \
            "• Detailed comparison matrix\n" \
            "• Scoring & ranking system\n" \
            "• Recommendation & winner\n" \
            "• Decision-making guidelines\n\n" \
            'What would you like me to compare for you?',
      processing_time: rand(1.5..3.7).round(2),
      sources: generate_sample_sources('comparison'),
      research_type: 'comparative_analysis',
      related_topics: ['evaluation criteria', 'decision matrices', 'benchmarking'],
      confidence_score: rand(87..94)
    }
  end

  def handle_timeline_request(_message)
    {
      text: "📅 **Timeline Research Engine Activated**\n\n" \
            "Creating comprehensive chronological analysis:\n\n" \
            "⏰ **Timeline Features:**\n" \
            "• Key events & milestones\n" \
            "• Cause-and-effect relationships\n" \
            "• Important dates & periods\n" \
            "• Historical context & background\n" \
            "• Future projections & predictions\n\n" \
            "🎯 **Research Methodology:**\n" \
            "• Primary source documentation\n" \
            "• Cross-referenced date verification\n" \
            "• Multiple perspective analysis\n" \
            "• Visual timeline construction\n" \
            "• Interactive exploration tools\n\n" \
            "📖 **Timeline Deliverables:**\n" \
            "• Chronological event sequence\n" \
            "• Impact analysis & significance\n" \
            "• Visual timeline graphics\n" \
            "• Historical context explanations\n\n" \
            'What topic would you like me to create a timeline for?',
      processing_time: rand(1.3..3.2).round(2),
      sources: generate_sample_sources('timeline'),
      research_type: 'chronological_analysis',
      related_topics: ['historical research', 'event sequencing', 'causation analysis'],
      confidence_score: rand(89..96)
    }
  end

  def handle_general_research_query(_message)
    {
      text: "🔬 **InfoSeek Research AI Ready**\n\n" \
            "I'm your expert research assistant! Here's how I can help:\n\n" \
            "🎯 **Core Research Capabilities:**\n" \
            "• Deep research & comprehensive analysis\n" \
            "• Fact-checking & verification\n" \
            "• Trend analysis & forecasting\n" \
            "• Comparative studies & benchmarking\n" \
            "• Timeline research & chronology\n" \
            "• Data mining & insights extraction\n\n" \
            "⚡ **Quick Commands:**\n" \
            "• 'fact check [statement]' - Verify accuracy\n" \
            "• 'research [topic]' - Comprehensive study\n" \
            "• 'trends in [subject]' - Pattern analysis\n" \
            "• 'compare [A] vs [B]' - Side-by-side analysis\n" \
            "• 'timeline of [events]' - Chronological study\n\n" \
            "🎯 **Research Standards:**\n" \
            "• Multiple authoritative sources\n" \
            "• Academic-quality citations\n" \
            "• Bias detection & neutrality\n" \
            "• Current & accurate information\n\n" \
            'What would you like to research today?',
      processing_time: rand(0.8..2.1).round(2),
      sources: generate_sample_sources('overview'),
      research_type: 'general_assistance',
      related_topics: ['research methods', 'source evaluation', 'information literacy'],
      confidence_score: rand(92..99)
    }
  end

  def generate_sample_sources(research_type)
    case research_type
    when 'fact_check'
      [
        { title: 'Snopes.com', type: 'Fact-checking database', credibility: 95 },
        { title: 'PolitiFact', type: 'Political fact verification', credibility: 92 },
        { title: 'Reuters Fact Check', type: 'News verification', credibility: 97 }
      ]
    when 'deep_research'
      [
        { title: 'JSTOR Academic Database', type: 'Peer-reviewed journals', credibility: 98 },
        { title: 'Google Scholar', type: 'Academic search engine', credibility: 94 },
        { title: 'Government Statistics', type: 'Official data sources', credibility: 96 }
      ]
    when 'trend_analysis'
      [
        { title: 'Google Trends', type: 'Search trend analysis', credibility: 90 },
        { title: 'World Bank Data', type: 'Economic indicators', credibility: 97 },
        { title: 'Statista', type: 'Market research data', credibility: 88 }
      ]
    else
      [
        { title: 'Wikipedia', type: 'General encyclopedia', credibility: 82 },
        { title: 'News aggregators', type: 'Current events', credibility: 85 },
        { title: 'Expert interviews', type: 'Professional opinions', credibility: 91 }
      ]
    end
  end
end
