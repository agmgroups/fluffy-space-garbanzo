# frozen_string_literal: true

class AiblogsterController < ApplicationController
  before_action :find_aiblogster_agent
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
      # Generate response using agent engine
      response = @agent.respond_to_user(@user, user_message, build_chat_context)

      render json: {
        success: true,
        response: response[:text],
        processing_time: response[:processing_time],
        agent_name: @agent.name,
        timestamp: Time.current.strftime('%H:%M:%S')
      }
    rescue StandardError => e
      Rails.logger.error "Aiblogster Error: #{e.message}"

      render json: {
        error: 'Sorry, I encountered an error processing your message. Please try again.',
        timestamp: Time.current.strftime('%H:%M:%S')
      }, status: :internal_server_error
    end
  end

  def generate_blog_post
    topic = params[:topic]&.strip
    style = params[:style] || 'professional'
    word_count = params[:word_count]&.to_i || 800

    if topic.blank?
      render json: { error: 'Topic is required' }, status: :bad_request
      return
    end

    begin
      blog_post = generate_ai_blog_content(topic, style, word_count)

      render json: {
        success: true,
        blog_post:,
        word_count: blog_post[:content].split.length,
        readability_score: calculate_readability(blog_post[:content]),
        seo_suggestions: generate_seo_suggestions(blog_post),
        timestamp: Time.current.strftime('%H:%M:%S')
      }
    rescue StandardError => e
      Rails.logger.error "Blog Generation Error: #{e.message}"
      render json: { error: 'Failed to generate blog post' }, status: :internal_server_error
    end
  end

  def analyze_content
    content = params[:content]&.strip

    if content.blank?
      render json: { error: 'Content is required' }, status: :bad_request
      return
    end

    analysis = {
      word_count: content.split.length,
      character_count: content.length,
      readability_score: calculate_readability(content),
      sentiment: analyze_sentiment(content),
      keywords: extract_keywords(content),
      seo_score: calculate_seo_score(content),
      suggestions: generate_content_suggestions(content)
    }

    render json: { success: true, analysis: }
  end

  def optimize_seo
    content = params[:content]
    target_keywords = params[:keywords]&.split(',')&.map(&:strip) || []

    optimized_content = apply_seo_optimization(content, target_keywords)

    render json: {
      success: true,
      original_content: content,
      optimized_content:,
      seo_improvements: generate_seo_improvements(content, optimized_content),
      keyword_density: calculate_keyword_density(optimized_content, target_keywords)
    }
  end

  def generate_ideas
    niche = params[:niche] || 'general'
    count = params[:count]&.to_i || 10

    ideas = generate_blog_ideas(niche, count)

    render json: {
      success: true,
      ideas:,
      niche:,
      trend_score: calculate_trend_scores(ideas)
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

  def find_aiblogster_agent
    @agent = Agent.find_by(agent_type: 'aiblogster', status: 'active')

    return if @agent

    redirect_to root_url(subdomain: false), alert: 'Aiblogster agent is currently unavailable'
  end

  def ensure_demo_user
    # Create or find a demo user for the session
    session_id = session[:user_session_id] ||= SecureRandom.uuid

    @user = User.find_or_create_by(email: "demo_#{session_id}@aiblogster.onelastai.com") do |user|
      user.name = "Aiblogster User #{rand(1000..9999)}"
      user.preferences = {
        communication_style: 'terminal',
        interface_theme: 'dark',
        response_detail: 'comprehensive'
      }.to_json
    end

    session[:current_user_id] = @user.id
  end

  def generate_ai_blog_content(topic, style, word_count)
    # Simulate AI blog generation
    {
      title: generate_blog_title(topic),
      content: generate_blog_body(topic, style, word_count),
      meta_description: generate_meta_description(topic),
      tags: generate_relevant_tags(topic),
      estimated_read_time: calculate_read_time(word_count)
    }
  end

  def generate_blog_title(topic)
    templates = [
      "The Ultimate Guide to #{topic}",
      "#{topic}: Everything You Need to Know",
      "Mastering #{topic} in 2025",
      "#{topic} Secrets That Actually Work",
      "The Future of #{topic}: Trends and Predictions"
    ]
    templates.sample
  end

  def generate_blog_body(topic, style, word_count)
    # Simulate content generation based on style
    intro = case style
            when 'professional'
              "In today's rapidly evolving landscape, #{topic} has become increasingly important for businesses and individuals alike."
            when 'casual'
              "Hey there! Let's dive into the fascinating world of #{topic} and explore what makes it so special."
            when 'technical'
              "#{topic} represents a complex intersection of various technological and methodological approaches."
            else
              "Understanding #{topic} is crucial in our modern digital environment."
            end

    # Generate paragraphs to reach target word count
    paragraphs = [intro]
    current_words = intro.split.length

    while current_words < word_count
      paragraph = generate_paragraph(topic)
      paragraphs << paragraph
      current_words += paragraph.split.length
    end

    paragraphs.join("\n\n")
  end

  def generate_paragraph(topic)
    sentences = [
      "The implementation of #{topic} requires careful consideration of multiple factors.",
      "Recent developments in #{topic} have shown promising results across various industries.",
      "Experts recommend a strategic approach when dealing with #{topic} challenges.",
      "The benefits of #{topic} extend far beyond initial expectations.",
      "Understanding the core principles of #{topic} is essential for success."
    ]
    sentences.sample(2).join(' ')
  end

  def calculate_readability(content)
    words = content.split.length
    sentences = content.split(/[.!?]+/).length
    syllables = content.split.sum { |word| count_syllables(word) }

    # Flesch Reading Ease Score
    score = 206.835 - (1.015 * (words.to_f / sentences)) - (84.6 * (syllables.to_f / words))
    score.round(1)
  end

  def count_syllables(word)
    # Simple syllable counting algorithm
    word.downcase.gsub(/[^a-z]/, '').scan(/[aeiouy]+/).length.clamp(1, Float::INFINITY)
  end

  def analyze_sentiment(content)
    positive_words = %w[amazing excellent great wonderful fantastic good better best love awesome]
    negative_words = %w[bad terrible awful hate worst horrible poor disappointing]

    words = content.downcase.split
    positive_count = words.count { |word| positive_words.include?(word) }
    negative_count = words.count { |word| negative_words.include?(word) }

    if positive_count > negative_count
      { score: 0.7, label: 'Positive' }
    elsif negative_count > positive_count
      { score: -0.7, label: 'Negative' }
    else
      { score: 0.0, label: 'Neutral' }
    end
  end

  def extract_keywords(content)
    # Simple keyword extraction
    words = content.downcase.gsub(/[^\w\s]/, '').split
    stop_words = %w[the a an and or but in on at to for of with by]

    keywords = words.reject { |word| stop_words.include?(word) || word.length < 4 }
    keyword_freq = keywords.tally

    keyword_freq.sort_by { |_, count| -count }.first(10).map { |word, count| { word:, frequency: count } }
  end

  def calculate_seo_score(content)
    # Basic SEO scoring
    word_count = content.split.length

    score = 0
    score += 20 if word_count >= 300
    score += 15 if content.include?('h1') || content.include?('h2')
    score += 10 if content.scan(%r{https?://}).length > 0
    score += 15 if content.length > 1000

    score.clamp(0, 100)
  end

  def generate_blog_ideas(niche, count)
    idea_templates = [
      "How to Master #{niche} in 30 Days",
      "The Beginner's Guide to #{niche}",
      "#{niche} Trends to Watch in 2025",
      "Common #{niche} Mistakes to Avoid",
      "#{niche} Tools Every Professional Should Know"
    ]

    count.times.map do
      {
        title: idea_templates.sample,
        difficulty: %w[Beginner Intermediate Advanced].sample,
        estimated_words: rand(500..2000),
        trending_score: rand(1..100)
      }
    end
  end

  def build_chat_context
    {
      interface_mode: 'terminal',
      subdomain: 'aiblogster',
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

  def generate_meta_description(topic)
    "Discover everything you need to know about #{topic}. Expert insights, practical tips, and actionable strategies."
  end

  def generate_relevant_tags(topic)
    base_tags = [topic.downcase]
    related_tags = ['guide', 'tips', '2025', 'best practices', 'tutorial']
    (base_tags + related_tags.sample(3)).uniq
  end

  def calculate_read_time(word_count)
    # Average reading speed is 200-250 words per minute
    minutes = (word_count / 225.0).ceil
    "#{minutes} min read"
  end

  def generate_content_suggestions(content)
    suggestions = []

    suggestions << 'Consider expanding the content to at least 300 words for better SEO' if content.split.length < 300

    suggestions << 'Add relevant external links to increase authority' if content.scan(%r{https?://}).empty?

    if !content.include?('#') && !content.include?('<h')
      suggestions << 'Use headings (H2, H3) to improve content structure'
    end

    suggestions << 'Add relevant images to enhance engagement' if content.length > 500

    suggestions
  end

  def apply_seo_optimization(content, keywords)
    # Simple SEO optimization simulation
    optimized = content.dup

    keywords.each do |keyword|
      # Ensure keyword appears in first paragraph if not already
      unless optimized.downcase.include?(keyword.downcase)
        first_sentence = optimized.split('.').first
        optimized = optimized.sub(first_sentence, "#{first_sentence}. #{keyword.capitalize} is essential for success")
      end
    end

    optimized
  end

  def generate_seo_improvements(_original, _optimized)
    [
      'Added target keywords to content',
      'Improved keyword density',
      'Enhanced readability',
      'Optimized content structure'
    ]
  end

  def calculate_keyword_density(content, keywords)
    total_words = content.split.length

    keywords.map do |keyword|
      occurrences = content.downcase.scan(keyword.downcase).length
      density = (occurrences.to_f / total_words * 100).round(2)
      { keyword:, density: "#{density}%" }
    end
  end

  def generate_seo_suggestions(_blog_post)
    [
      'Add alt text to images',
      'Include internal links',
      'Optimize meta description length',
      'Use schema markup',
      'Add social media meta tags'
    ]
  end

  def calculate_trend_scores(ideas)
    ideas.map { |idea| idea[:trending_score] }.sum / ideas.length
  end
end
