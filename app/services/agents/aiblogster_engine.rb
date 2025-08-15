# frozen_string_literal: true

module Agents
  class AiblogsterEngine < BaseEngine
    def initialize(agent)
      @agent = agent
      @agent_name = "AIBlogster"
      @specializations = ["blog_writing", "seo_optimization", "content_planning", "research"]
      @personality = ["creative", "professional", "engaging", "knowledgeable"]
      @capabilities = ["blog_posts", "articles", "content_strategy", "seo_analysis"]
    end
    
    def process_input(user, input, context = {})
      start_time = Time.current
      
      # Analyze the blog content request
      content_analysis = analyze_blog_request(input)
      
      # Generate specialized blog response
      response_text = generate_blog_response(input, content_analysis, context)
      
      processing_time = (Time.current - start_time).round(3)
      
      {
        text: response_text,
        processing_time: processing_time,
        content_type: content_analysis[:content_type],
        seo_suggestions: content_analysis[:seo_keywords],
        tone: content_analysis[:tone]
      }
    end
    
    private
    
    def analyze_blog_request(input)
      input_lower = input.downcase
      
      # Detect content type
      content_type = if input_lower.include?('tutorial') || input_lower.include?('how to')
        'tutorial'
      elsif input_lower.include?('review') || input_lower.include?('opinion')
        'review'
      elsif input_lower.include?('news') || input_lower.include?('update')
        'news'
      elsif input_lower.include?('list') || input_lower.include?('top')
        'listicle'
      else
        'general_blog'
      end
      
      # Extract SEO keywords
      seo_keywords = extract_keywords(input)
      
      # Determine tone
      tone = if input_lower.include?('professional') || input_lower.include?('business')
        'professional'
      elsif input_lower.include?('casual') || input_lower.include?('friendly')
        'casual'
      elsif input_lower.include?('technical') || input_lower.include?('expert')
        'technical'
      else
        'balanced'
      end
      
      {
        content_type: content_type,
        seo_keywords: seo_keywords,
        tone: tone,
        word_count: estimate_word_count(input)
      }
    end
    
    def generate_blog_response(input, analysis, context)
      case analysis[:content_type]
      when 'tutorial'
        generate_tutorial_response(input, analysis)
      when 'review'
        generate_review_response(input, analysis)
      when 'listicle'
        generate_listicle_response(input, analysis)
      when 'news'
        generate_news_response(input, analysis)
      else
        generate_general_blog_response(input, analysis)
      end
    end
    
    def generate_tutorial_response(input, analysis)
      "📝 **AIBlogster Tutorial Mode Activated!**\n\n" +
      "Great choice for a tutorial! I'll help you create step-by-step content that's engaging and SEO-optimized.\n\n" +
      "**Content Strategy:**\n" +
      "• Structure: Introduction → Step-by-step guide → Conclusion\n" +
      "• SEO Focus: #{analysis[:seo_keywords].join(', ')}\n" +
      "• Tone: #{analysis[:tone].humanize}\n\n" +
      "**Next Steps:**\n" +
      "1. Define your target audience\n" +
      "2. Outline the main steps\n" +
      "3. Add practical examples\n" +
      "4. Include relevant screenshots/images\n\n" +
      "Ready to start crafting your tutorial? What specific steps should we cover?"
    end
    
    def generate_review_response(input, analysis)
      "⭐ **AIBlogster Review Mode Activated!**\n\n" +
      "Perfect! I'll help you create a comprehensive and honest review that readers will trust.\n\n" +
      "**Review Framework:**\n" +
      "• Introduction & First Impressions\n" +
      "• Detailed Analysis (Pros & Cons)\n" +
      "• Comparison with alternatives\n" +
      "• Final verdict & recommendations\n\n" +
      "**SEO Keywords:** #{analysis[:seo_keywords].join(', ')}\n" +
      "**Writing Style:** #{analysis[:tone].humanize}\n\n" +
      "What product, service, or topic are you reviewing? I'll help you structure compelling content!"
    end
    
    def generate_listicle_response(input, analysis)
      "📋 **AIBlogster Listicle Mode Activated!**\n\n" +
      "Excellent choice! Lists are highly engaging and perfect for SEO. Let's create something viral-worthy!\n\n" +
      "**Listicle Strategy:**\n" +
      "• Compelling headline with numbers\n" +
      "• Introduction that hooks readers\n" +
      "• Well-researched list items\n" +
      "• Strong conclusion with CTA\n\n" +
      "**Optimization Focus:** #{analysis[:seo_keywords].join(', ')}\n" +
      "**Tone:** #{analysis[:tone].humanize}\n\n" +
      "How many items should we include? What's the main theme of your list?"
    end
    
    def generate_news_response(input, analysis)
      "📰 **AIBlogster News Mode Activated!**\n\n" +
      "Breaking news content! I'll help you create timely, accurate, and engaging news articles.\n\n" +
      "**News Article Structure:**\n" +
      "• Compelling headline\n" +
      "• Lead paragraph (Who, What, When, Where, Why)\n" +
      "• Supporting details and quotes\n" +
      "• Background information\n" +
      "• Impact and implications\n\n" +
      "**SEO Focus:** #{analysis[:seo_keywords].join(', ')}\n\n" +
      "What's the news angle? Let's make sure we cover all the essential details!"
    end
    
    def generate_general_blog_response(input, analysis)
      "✨ **AIBlogster Creative Mode Activated!**\n\n" +
      "I'm ready to help you create amazing blog content! Based on your request, here's my approach:\n\n" +
      "**Content Plan:**\n" +
      "• Research target audience needs\n" +
      "• Create compelling hook and introduction\n" +
      "• Develop main content with clear structure\n" +
      "• Add SEO optimization throughout\n" +
      "• Craft strong conclusion with engagement\n\n" +
      "**Keywords to target:** #{analysis[:seo_keywords].join(', ')}\n" +
      "**Writing tone:** #{analysis[:tone].humanize}\n\n" +
      "What specific angle or unique perspective should we take? Let's create content that stands out!"
    end
    
    def extract_keywords(input)
      # Simple keyword extraction
      words = input.downcase.gsub(/[^\w\s]/, '').split
      
      # Filter out common words and keep potential keywords
      stop_words = %w[the and or but is are was were been have has had do does did will would could should may might can]
      keywords = words.reject { |word| stop_words.include?(word) || word.length < 3 }
      
      keywords.uniq.first(5)
    end
    
    def estimate_word_count(input)
      # Estimate desired word count based on content type mentions
      if input.downcase.include?('short') || input.downcase.include?('brief')
        '500-800 words'
      elsif input.downcase.include?('detailed') || input.downcase.include?('comprehensive')
        '1500-2500 words'
      elsif input.downcase.include?('long') || input.downcase.include?('in-depth')
        '2000-3000 words'
      else
        '1000-1500 words'
      end
    end
  end
end
