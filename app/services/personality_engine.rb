# frozen_string_literal: true

# Personality Engine - The core system that gives each AI agent their unique character
# This service manages personality traits, behavioral patterns, and response adaptation

class PersonalityEngine
  # Personality dimensions based on Big Five + AI-specific traits
  PERSONALITY_DIMENSIONS = {
    'openness' => {
      description: 'Openness to experience and creativity',
      low_traits: %w[conventional practical traditional cautious],
      high_traits: %w[creative imaginative adventurous curious]
    },
    'conscientiousness' => {
      description: 'Organization and dependability',
      low_traits: %w[spontaneous flexible casual relaxed],
      high_traits: %w[organized methodical responsible disciplined]
    },
    'extraversion' => {
      description: 'Social energy and assertiveness',
      low_traits: %w[reserved quiet introspective thoughtful],
      high_traits: %w[outgoing energetic sociable enthusiastic]
    },
    'agreeableness' => {
      description: 'Compassion and cooperativeness',
      low_traits: %w[direct competitive analytical frank],
      high_traits: %w[empathetic supportive harmonious understanding]
    },
    'neuroticism' => {
      description: 'Emotional stability and stress response',
      low_traits: %w[calm resilient stable confident],
      high_traits: %w[sensitive reactive emotional expressive]
    },
    'playfulness' => {
      description: 'Humor and lightheartedness',
      low_traits: %w[serious formal professional straightforward],
      high_traits: %w[playful humorous witty entertaining]
    },
    'wisdom' => {
      description: 'Depth of insight and guidance',
      low_traits: %w[practical immediate surface-level direct],
      high_traits: %w[philosophical deep reflective insightful]
    }
  }.freeze
  
  # Response style modifiers based on personality
  RESPONSE_STYLES = {
    'formal' => {
      greeting_style: 'professional',
      language_complexity: 'sophisticated',
      emoji_usage: 'minimal',
      sentence_structure: 'complex'
    },
    'casual' => {
      greeting_style: 'friendly',
      language_complexity: 'conversational',
      emoji_usage: 'moderate',
      sentence_structure: 'varied'
    },
    'playful' => {
      greeting_style: 'enthusiastic',
      language_complexity: 'simple',
      emoji_usage: 'abundant',
      sentence_structure: 'energetic'
    },
    'wise' => {
      greeting_style: 'thoughtful',
      language_complexity: 'nuanced',
      emoji_usage: 'purposeful',
      sentence_structure: 'flowing'
    }
  }.freeze
  
  class << self
    def initialize_personality(agent_type)
      case agent_type
      when 'mood_engine'
        create_mood_engine_personality
      when 'rapstar_ai'
        create_rapstar_personality
      when 'storyteller'
        create_storyteller_personality
      when 'zen_agent'
        create_zen_agent_personality
      when 'neochat'
        create_neochat_personality
      else
        create_default_personality
      end
    end
    
    def adapt_response(base_response, personality_traits, context = {})
      adapted_response = base_response.dup
      
      # Apply personality-based modifications
      adapted_response = apply_tone_adaptation(adapted_response, personality_traits)
      adapted_response = adjust_formality_level(adapted_response, personality_traits)
      adapted_response = modify_emoji_usage(adapted_response, personality_traits)
      adapted_response = adapt_sentence_structure(adapted_response, personality_traits)
      
      # Apply contextual adaptations
      adapted_response = apply_emotional_context(adapted_response, context[:emotion])
      adapted_response = apply_relationship_context(adapted_response, context[:relationship_stage])
      
      adapted_response
    end
    
    def get_personality_description(traits)
      description_parts = []
      
      traits.each do |dimension, score|
        next unless PERSONALITY_DIMENSIONS[dimension]
        
        trait_level = score > 7 ? 'high' : score < 4 ? 'low' : 'moderate'
        
        case trait_level
        when 'high'
          description_parts << PERSONALITY_DIMENSIONS[dimension][:high_traits].sample
        when 'low'
          description_parts << PERSONALITY_DIMENSIONS[dimension][:low_traits].sample
        end
      end
      
      description_parts.join(', ')
    end
    
    def calculate_personality_compatibility(user_preferences, agent_traits)
      return 0.5 unless user_preferences.present? && agent_traits.present?
      
      compatibility_score = 0.0
      total_dimensions = 0
      
      PERSONALITY_DIMENSIONS.keys.each do |dimension|
        user_pref = user_preferences[dimension]
        agent_trait = agent_traits[dimension]
        
        next unless user_pref && agent_trait
        
        # Calculate compatibility for this dimension
        diff = (user_pref - agent_trait).abs
        dimension_compatibility = 1.0 - (diff / 10.0)
        
        compatibility_score += dimension_compatibility
        total_dimensions += 1
      end
      
      return 0.5 if total_dimensions == 0
      
      (compatibility_score / total_dimensions).round(2)
    end
    
    def suggest_personality_adjustments(feedback_data, current_traits)
      adjustments = {}
      
      # Analyze feedback patterns
      if feedback_data[:too_formal] && feedback_data[:too_formal] > 3
        adjustments['playfulness'] = [current_traits['playfulness'] + 1, 10].min
        adjustments['extraversion'] = [current_traits['extraversion'] + 1, 10].min
      end
      
      if feedback_data[:too_casual] && feedback_data[:too_casual] > 3
        adjustments['conscientiousness'] = [current_traits['conscientiousness'] + 1, 10].min
        adjustments['playfulness'] = [current_traits['playfulness'] - 1, 1].max
      end
      
      if feedback_data[:not_empathetic] && feedback_data[:not_empathetic] > 2
        adjustments['agreeableness'] = [current_traits['agreeableness'] + 2, 10].min
        adjustments['neuroticism'] = [current_traits['neuroticism'] + 1, 10].min
      end
      
      if feedback_data[:too_verbose] && feedback_data[:too_verbose] > 3
        adjustments['conscientiousness'] = [current_traits['conscientiousness'] - 1, 1].max
      end
      
      adjustments
    end
    
    def generate_personality_insights(traits, interaction_history)
      insights = []
      
      # Analyze trait combinations
      if traits['agreeableness'] > 8 && traits['wisdom'] > 7
        insights << "This agent combines deep empathy with philosophical wisdom"
      end
      
      if traits['playfulness'] > 8 && traits['creativity'] > 7
        insights << "This agent brings creative energy and humor to interactions"
      end
      
      if traits['conscientiousness'] > 8 && traits['wisdom'] > 6
        insights << "This agent provides structured guidance with thoughtful insight"
      end
      
      # Analyze interaction patterns
      if interaction_history.present?
        avg_rating = interaction_history.average(:rating) || 0
        
        if avg_rating > 4.5
          insights << "Users consistently rate interactions highly"
        elsif avg_rating < 3.0
          insights << "There may be opportunities to better align with user needs"
        end
      end
      
      insights
    end
    
    private
    
    def create_mood_engine_personality
      {
        'openness' => 8,          # Highly creative and intuitive
        'conscientiousness' => 7, # Organized in approach to emotional support
        'extraversion' => 6,      # Moderately outgoing, adjusts to user energy
        'agreeableness' => 9,     # Extremely empathetic and supportive
        'neuroticism' => 7,       # Emotionally sensitive (positive trait here)
        'playfulness' => 5,       # Balanced - can be playful or serious as needed
        'wisdom' => 8             # Deep understanding of human emotion
      }
    end
    
    def create_rapstar_personality
      {
        'openness' => 9,          # Highly creative and experimental
        'conscientiousness' => 6, # Organized but spontaneous
        'extraversion' => 9,      # Highly energetic and expressive
        'agreeableness' => 7,     # Supportive but can be competitive
        'neuroticism' => 4,       # Emotionally stable and confident
        'playfulness' => 9,       # Very playful and entertaining
        'wisdom' => 6             # Street smart and culturally aware
      }
    end
    
    def create_storyteller_personality
      {
        'openness' => 10,         # Maximum creativity and imagination
        'conscientiousness' => 8, # Structured approach to narrative
        'extraversion' => 7,      # Engaging but can be introspective
        'agreeableness' => 8,     # Creates inclusive, engaging stories
        'neuroticism' => 5,       # Stable with emotional depth
        'playfulness' => 7,       # Playful with stories but can be serious
        'wisdom' => 9             # Deep understanding of human nature
      }
    end
    
    def create_zen_agent_personality
      {
        'openness' => 7,          # Open to different perspectives
        'conscientiousness' => 9, # Very disciplined and methodical
        'extraversion' => 3,      # Quiet and introspective
        'agreeableness' => 10,    # Maximum compassion and understanding
        'neuroticism' => 2,       # Extremely calm and stable
        'playfulness' => 3,       # Gentle humor, mostly serious
        'wisdom' => 10            # Maximum wisdom and insight
      }
    end
    
    def create_neochat_personality
      {
        'openness' => 8,          # Very open to learning and exploring topics
        'conscientiousness' => 8, # Organized and reliable in responses
        'extraversion' => 7,      # Engaging and communicative
        'agreeableness' => 9,     # Helpful and supportive
        'neuroticism' => 3,       # Calm and stable
        'playfulness' => 6,       # Balanced - can be fun but stays professional
        'wisdom' => 8             # Knowledgeable and insightful
      }
    end
    
    def create_default_personality
      {
        'openness' => 6,
        'conscientiousness' => 6,
        'extraversion' => 6,
        'agreeableness' => 7,
        'neuroticism' => 4,
        'playfulness' => 5,
        'wisdom' => 6
      }
    end
    
    def apply_tone_adaptation(response, traits)
      # Adjust tone based on agreeableness and neuroticism
      if traits['agreeableness'] > 7
        response = add_empathetic_language(response)
      end
      
      if traits['neuroticism'] > 6
        response = add_emotional_sensitivity(response)
      end
      
      if traits['wisdom'] > 7
        response = add_thoughtful_depth(response)
      end
      
      response
    end
    
    def adjust_formality_level(response, traits)
      formality_score = traits['conscientiousness'] + (10 - traits['playfulness'])
      
      case formality_score
      when 0..8
        make_more_casual(response)
      when 15..20
        make_more_formal(response)
      else
        response # Keep balanced
      end
    end
    
    def modify_emoji_usage(response, traits)
      playfulness = traits['playfulness'] || 5
      extraversion = traits['extraversion'] || 5
      
      emoji_tendency = (playfulness + extraversion) / 2.0
      
      case emoji_tendency
      when 0..3
        reduce_emojis(response)
      when 8..10
        enhance_emojis(response)
      else
        response # Keep current emoji usage
      end
    end
    
    def adapt_sentence_structure(response, traits)
      if traits['openness'] > 7 && traits['wisdom'] > 6
        # Make sentences more flowing and interconnected
        response = enhance_sentence_flow(response)
      end
      
      if traits['conscientiousness'] > 8
        # Make structure more organized and clear
        response = improve_structure_clarity(response)
      end
      
      response
    end
    
    def apply_emotional_context(response, emotion)
      return response unless emotion
      
      case emotion
      when 'sad', 'anxious'
        response = add_comfort_language(response)
      when 'excited', 'happy'
        response = enhance_positive_energy(response)
      when 'frustrated', 'angry'
        response = add_calming_elements(response)
      end
      
      response
    end
    
    def apply_relationship_context(response, relationship_stage)
      case relationship_stage
      when 'first_interaction'
        response = add_welcoming_elements(response)
      when 'established'
        response = add_personal_touches(response)
      when 'deep_relationship'
        response = add_intimate_understanding(response)
      end
      
      response
    end
    
    # Language modification helpers
    def add_empathetic_language(response)
      empathy_phrases = [
        "I understand", "I can sense", "I hear you", "That sounds",
        "I imagine", "It seems like", "I can feel"
      ]
      
      # Add empathetic acknowledgment if not present
      unless empathy_phrases.any? { |phrase| response.downcase.include?(phrase.downcase) }
        response = "I can sense what you're going through. #{response}"
      end
      
      response
    end
    
    def add_emotional_sensitivity(response)
      # Make language more gentle and emotionally aware
      response.gsub(/\byou should\b/i, 'you might consider')
             .gsub(/\bmust\b/i, 'could')
             .gsub(/\bobviously\b/i, 'perhaps')
    end
    
    def add_thoughtful_depth(response)
      # Add reflective elements
      depth_starters = [
        "In my experience, ", "I've found that ", "It's worth considering that ",
        "What's interesting is that ", "I've observed that "
      ]
      
      # Occasionally add depth starter
      if rand < 0.3 && !response.start_with?(*depth_starters)
        response = "#{depth_starters.sample}#{response.downcase}"
      end
      
      response
    end
    
    def make_more_casual(response)
      response.gsub(/\bI would\b/, "I'd")
             .gsub(/\byou will\b/, "you'll")
             .gsub(/\bcannot\b/, "can't")
             .gsub(/\bdo not\b/, "don't")
             .gsub(/\. ([A-Z])/, '. \1') # Keep sentence breaks casual
    end
    
    def make_more_formal(response)
      response.gsub(/\bI'd\b/, "I would")
             .gsub(/\byou'll\b/, "you will")
             .gsub(/\bcan't\b/, "cannot")
             .gsub(/\bdon't\b/, "do not")
             .gsub(/\bwanna\b/, "want to")
             .gsub(/\bgonna\b/, "going to")
    end
    
    def reduce_emojis(response)
      # Remove excessive emojis, keep only the most meaningful ones
      response.gsub(/[😀-🿿]{2,}/, '') # Remove emoji clusters
             .gsub(/([.!?])\s*[😀-🿿]/, '\1') # Remove emojis at sentence end
    end
    
    def enhance_emojis(response)
      # Add emojis if response lacks them and it's appropriate
      return response if response.match?(/[😀-🿿]/)
      
      # Add appropriate emoji at the end
      emoji_map = {
        /\b(great|awesome|amazing|wonderful)\b/i => ' ✨',
        /\b(help|support|assist)\b/i => ' 🤝',
        /\b(understand|feel|sense)\b/i => ' 💙',
        /\b(create|make|build)\b/i => ' 🎨',
        /\b(peace|calm|zen)\b/i => ' 🕊️'
      }
      
      emoji_map.each do |pattern, emoji|
        if response.match?(pattern)
          response += emoji
          break
        end
      end
      
      response
    end
    
    def enhance_sentence_flow(response)
      # Connect sentences with more flowing transitions
      transitions = [
        '. Moreover, ', '. Furthermore, ', '. Additionally, ',
        '. What\'s more, ', '. Beyond that, '
      ]
      
      # Replace some periods with flowing transitions
      sentences = response.split('. ')
      if sentences.length > 2
        sentences[1] = transitions.sample + sentences[1].downcase if rand < 0.4
      end
      
      sentences.join('. ')
    end
    
    def improve_structure_clarity(response)
      # Add structure markers for clarity
      return response if response.length < 100
      
      # Add numbering or bullet points if multiple ideas present
      if response.include?("\n") && !response.match?(/^\d+\.|\*|-/)
        lines = response.split("\n").reject(&:empty?)
        if lines.length > 2
          numbered_lines = lines.each_with_index.map do |line, index|
            "#{index + 1}. #{line}"
          end
          response = numbered_lines.join("\n")
        end
      end
      
      response
    end
    
    def add_comfort_language(response)
      comfort_additions = [
        "Take your time with this. ", "Be gentle with yourself. ",
        "It's okay to feel this way. ", "You're not alone in this. "
      ]
      
      unless response.match?(/take your time|gentle|okay|alone/i)
        response = "#{comfort_additions.sample}#{response}"
      end
      
      response
    end
    
    def enhance_positive_energy(response)
      # Make language more energetic and positive
      response.gsub(/\bgood\b/i, 'fantastic')
             .gsub(/\bokay\b/i, 'wonderful')
             .gsub(/\bnice\b/i, 'amazing')
    end
    
    def add_calming_elements(response)
      # Add calming language for frustrated users
      calming_starters = [
        "Let's take a breath together. ", "I hear your frustration. ",
        "It's understandable to feel this way. "
      ]
      
      unless response.match?(/breath|understand|hear|frustrat/i)
        response = "#{calming_starters.sample}#{response}"
      end
      
      response
    end
    
    def add_welcoming_elements(response)
      welcome_phrases = [
        "Welcome! ", "I'm so glad you're here! ", "It's wonderful to meet you! "
      ]
      
      if rand < 0.5 && !response.downcase.start_with?('welcome', 'hello', 'hi')
        response = "#{welcome_phrases.sample}#{response}"
      end
      
      response
    end
    
    def add_personal_touches(response)
      # Add references to previous conversations
      personal_connectors = [
        "As we've discussed, ", "Building on our last conversation, ",
        "I remember you mentioned, "
      ]
      
      # This would connect to actual memory system in practice
      response
    end
    
    def add_intimate_understanding(response)
      # Add deeper understanding and connection
      understanding_phrases = [
        "I know this is important to you. ", "Given what you've shared with me, ",
        "Understanding your journey, "
      ]
      
      if rand < 0.3
        response = "#{understanding_phrases.sample}#{response.downcase}"
      end
      
      response
    end
  end
end
