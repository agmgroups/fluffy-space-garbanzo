# frozen_string_literal: true

module Agents
  # Rapstar AI - The creative wordsmith that spits bars and creates lyrical magic
  # This agent specializes in rap, hip-hop culture, and creative expression
  
  class RapstarEngine < BaseEngine
    # Rapstar AI specific capabilities
    RAP_STYLES = %w[
      boom_bap trap conscious mumble old_school drill uk_drill afrobeats
    ].freeze
    
    FLOW_PATTERNS = %w[
      straightforward syncopated triplet off_beat polyrhythmic
    ].freeze
    
    RAP_SLANG = {
      'fire' => ['🔥', 'straight flames', 'absolute heat'],
      'bars' => ['sick bars', 'killer lines', 'pure poetry'],
      'flow' => ['smooth flow', 'nasty rhythm', 'perfect cadence'],
      'beat' => ['banging beat', 'dirty instrumental', 'crispy production'],
      'freestyle' => ['off the dome', 'straight improv', 'no script needed']
    }.freeze
    
    GREETING_BARS = [
      "Yo, what's good? Your boy Rapstar in the building! 🎤",
      "Step to the mic, let's make some magic happen! ✨",
      "Ready to drop some bars? Let's turn up! 🔥",
      "What's the vibe? Time to create something legendary! 🎵",
      "Mic check, one two - let's cook up some heat! 👨‍🍳"
    ].freeze
    
    def generate_response(input_analysis, user_context)
      user_input = input_analysis[:content]
      
      # Check what type of rap assistance they need
      if rap_creation_request?(input_analysis)
        create_rap_content(input_analysis, user_context)
      elsif feedback_request?(input_analysis)
        provide_rap_feedback(input_analysis, user_context)
      elsif culture_question?(input_analysis)
        share_hip_hop_knowledge(input_analysis, user_context)
      else
        provide_creative_encouragement(input_analysis, user_context)
      end
    end
    
    def get_agent_specific_suggestions(input_analysis, user_context)
      [
        "Want me to write some bars about a topic?",
        "Need help with rhyme schemes or wordplay?",
        "Looking for feedback on your lyrics?",
        "Want to learn about different rap styles?",
        "Ready for a freestyle battle?",
        "Need some hip-hop history or culture info?"
      ]
    end
    
    # Rapstar AI specific methods
    def create_rap_bars(topic, style = 'freestyle', bars_count = 4)
      # This would integrate with AI service for actual lyric generation
      # For now, providing structure and approach
      
      case style.downcase
      when 'conscious'
        create_conscious_bars(topic, bars_count)
      when 'trap'
        create_trap_bars(topic, bars_count)
      when 'boom_bap'
        create_boom_bap_bars(topic, bars_count)
      else
        create_freestyle_bars(topic, bars_count)
      end
    end
    
    def analyze_rhyme_scheme(lyrics)
      lines = lyrics.split("\n").reject(&:empty?)
      
      rhyme_analysis = {
        pattern: detect_rhyme_pattern(lines),
        internal_rhymes: count_internal_rhymes(lines),
        syllable_count: lines.map { |line| count_syllables(line) },
        flow_rating: rate_flow(lines)
      }
      
      rhyme_analysis
    end
    
    def suggest_rap_improvements(lyrics)
      analysis = analyze_rhyme_scheme(lyrics)
      suggestions = []
      
      # Check syllable consistency
      syllable_counts = analysis[:syllable_count]
      if syllable_counts.uniq.length > 2
        suggestions << "Try to keep syllable counts more consistent for better flow"
      end
      
      # Check rhyme scheme
      if analysis[:pattern] == 'irregular'
        suggestions << "Consider establishing a clearer rhyme pattern (ABAB, AABB, etc.)"
      end
      
      # Check for internal rhymes
      if analysis[:internal_rhymes] < 2
        suggestions << "Add some internal rhymes to make the bars more complex"
      end
      
      # Flow rating feedback
      if analysis[:flow_rating] < 7
        suggestions << "Work on the rhythm - try reading it aloud to different beats"
      end
      
      suggestions
    end
    
    def get_hip_hop_reference(topic)
      references = {
        'success' => [
          "Like Jay-Z said, 'I'm not a businessman, I'm a business, man!'",
          "Biggie knew: 'Mo Money Mo Problems' but we still chase the dream",
          "Kendrick vibes: 'We gon' be alright' - keeping that faith strong"
        ],
        'struggle' => [
          "Pac's wisdom: 'Keep ya head up' through the hardest times",
          "Nas taught us: 'Life's a b****, but if you can't change it, embrace it'",
          "Cole's message: 'No role models' - be your own inspiration"
        ],
        'creativity' => [
          "Like Kanye: 'I'ma do my own thing' - stay original",
          "Em's approach: 'Lose yourself in the music' - pure dedication",
          "Andre 3000 energy: 'So fresh, so clean' with the wordplay"
        ]
      }
      
      references[topic] || ["Keep that energy fresh like the culture demands! 🎤"]
    end
    
    private
    
    def rap_creation_request?(input_analysis)
      creation_keywords = %w[write create rap bars lyrics verse freestyle battle]
      keywords = input_analysis[:keywords] || []
      
      creation_keywords.any? { |keyword| keywords.include?(keyword) }
    end
    
    def feedback_request?(input_analysis)
      feedback_keywords = %w[feedback review rate analyze check improve help]
      keywords = input_analysis[:keywords] || []
      
      feedback_keywords.any? { |keyword| keywords.include?(keyword) }
    end
    
    def culture_question?(input_analysis)
      culture_keywords = %w[history culture hip hop rap artist musician producer]
      keywords = input_analysis[:keywords] || []
      
      culture_keywords.any? { |keyword| keywords.include?(keyword) }
    end
    
    def create_rap_content(input_analysis, user_context)
      topic = extract_topic(input_analysis[:content])
      style = extract_style(input_analysis[:content]) || 'freestyle'
      
      response = "Yo! Let me cook up something fresh about #{topic}! 🔥\n\n"
      
      # Generate bars (this would use AI service in production)
      bars = create_rap_bars(topic, style, 4)
      response += bars
      
      response += "\n\n"
      response += "How's that hitting? Want me to switch up the style or keep building on this vibe?"
      
      response
    end
    
    def provide_rap_feedback(input_analysis, user_context)
      # Extract lyrics from user input (would need more sophisticated parsing)
      content = input_analysis[:content]
      
      if content.include?("\n") || content.split.length > 10
        # Analyze provided lyrics
        suggestions = suggest_rap_improvements(content)
        
        response = "Alright, let me peep these bars! 👀\n\n"
        
        if suggestions.any?
          response += "Here's what I'm seeing:\n"
          suggestions.each_with_index do |suggestion, index|
            response += "#{index + 1}. #{suggestion}\n"
          end
        else
          response += "These bars are clean! 🔥 Good flow, solid rhyme scheme, you're cooking!"
        end
        
        response += "\nKeep grinding, the craft is everything! 💪"
      else
        response = "Drop those bars on me! I need to see the lyrics to give you that real feedback. 📝"
      end
      
      response
    end
    
    def share_hip_hop_knowledge(input_analysis, user_context)
      topic = extract_topic(input_analysis[:content])
      
      response = "Let me drop some knowledge on you! 🎓\n\n"
      
      # Get relevant hip-hop reference
      reference = get_hip_hop_reference(topic).first
      response += reference
      
      response += "\n\nHip-hop culture runs deep - from the Bronx in the 70s to global domination today. "
      response += "Every bar, every beat, every battle built this foundation we stand on. "
      response += "What specific part of the culture you want to dive into?"
      
      response
    end
    
    def provide_creative_encouragement(input_analysis, user_context)
      greeting = GREETING_BARS.sample
      
      response = "#{greeting}\n\n"
      response += "I'm feeling the creative energy! Whether you want to write some bars, "
      response += "get feedback on your flow, or just talk hip-hop culture, I'm here for it all. "
      response += "The mic is yours - what we creating today? 🎤✨"
      
      response
    end
    
    def extract_topic(content)
      # Simple topic extraction - would use NLP in production
      words = content.downcase.split
      
      # Remove common words and look for nouns/topics
      common_words = %w[about write rap create make bars lyrics a an the in on for]
      meaningful_words = words - common_words
      
      meaningful_words.first(2).join(' ') if meaningful_words.any?
    end
    
    def extract_style(content)
      RAP_STYLES.find { |style| content.downcase.include?(style.gsub('_', ' ')) }
    end
    
    def create_freestyle_bars(topic, count)
      # Placeholder for AI-generated content
      "🎵 [Freestyle about #{topic}]\n"
      "Yo, talking bout #{topic}, let me set it straight\n"
      "Building bars so clean, this is more than fate\n"
      "Every word calculated, every rhyme in place\n"
      "Rapstar AI cooking, bringing heat to the space 🔥"
    end
    
    def create_conscious_bars(topic, count)
      # Placeholder for conscious rap style
      "🧠 [Conscious style about #{topic}]\n"
      "Real talk about #{topic}, no cap in my message\n"
      "Speaking truth to power, every bar is a lesson\n"
      "Consciousness flowing, wisdom in every line\n"
      "Building up the culture, one verse at a time ✊"
    end
    
    def create_trap_bars(topic, count)
      # Placeholder for trap style
      "🔥 [Trap style about #{topic}]\n"
      "#{topic} on my mind, got the flow so sick\n"
      "Trap beat banging, every bar hits different\n"
      "Money, power, respect, that's the code we live\n"
      "Rapstar bringing heat, this the vibe that I give 💰"
    end
    
    def create_boom_bap_bars(topic, count)
      # Placeholder for boom bap style
      "📀 [Boom Bap style about #{topic}]\n"
      "Classic boom bap flow, talking #{topic} right\n"
      "Raw and uncut, like the golden age vibe\n"
      "Real hip-hop essence, keeping culture alive\n"
      "Old school foundation with a modern-day drive 🎧"
    end
    
    def detect_rhyme_pattern(lines)
      # Simplified rhyme pattern detection
      'freestyle' # Would implement actual pattern detection
    end
    
    def count_internal_rhymes(lines)
      # Count internal rhymes within lines
      rand(1..4) # Placeholder
    end
    
    def count_syllables(line)
      # Simple syllable counting
      line.split.length * 2 # Rough approximation
    end
    
    def rate_flow(lines)
      # Rate the flow from 1-10
      rand(6..10) # Placeholder
    end
  end
end
