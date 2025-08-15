# frozen_string_literal: true

# Emotion Analyzer - Advanced emotion detection and analysis system
# This service handles emotion recognition, sentiment analysis, and emotional context understanding

class EmotionAnalyzer
  # Core emotions with intensity levels and indicators
  CORE_EMOTIONS = {
    'happy' => {
      synonyms: %w[joyful excited cheerful delighted pleased glad content satisfied],
      intensity_indicators: {
        low: %w[okay good fine pleased],
        medium: %w[happy glad cheerful satisfied],
        high: %w[ecstatic thrilled overjoyed elated jubilant]
      },
      physical_indicators: %w[smiling laughing dancing celebrating]
    },
    'sad' => {
      synonyms: %w[unhappy depressed melancholy sorrowful gloomy downcast dejected],
      intensity_indicators: {
        low: %w[down blue disappointed],
        medium: %w[sad unhappy upset],
        high: %w[devastated heartbroken despairing]
      },
      physical_indicators: %w[crying tears weeping sobbing]
    },
    'angry' => {
      synonyms: %w[mad furious irritated annoyed frustrated enraged livid],
      intensity_indicators: {
        low: %w[annoyed bothered irritated],
        medium: %w[angry mad upset],
        high: %w[furious enraged livid incensed]
      },
      physical_indicators: %w[yelling shouting clenched fists]
    },
    'anxious' => {
      synonyms: %w[worried nervous stressed fearful apprehensive uneasy tense],
      intensity_indicators: {
        low: %w[concerned worried uneasy],
        medium: %w[anxious nervous stressed],
        high: %w[panicked terrified petrified]
      },
      physical_indicators: %w[shaking trembling sweating racing heart]
    },
    'excited' => {
      synonyms: %w[enthusiastic eager thrilled pumped energetic animated],
      intensity_indicators: {
        low: %w[interested curious eager],
        medium: %w[excited enthusiastic],
        high: %w[ecstatic pumped fired up]
      },
      physical_indicators: %w[jumping bouncing clapping energetic]
    },
    'calm' => {
      synonyms: %w[peaceful relaxed serene tranquil composed centered],
      intensity_indicators: {
        low: %w[okay settled],
        medium: %w[calm relaxed peaceful],
        high: %w[serene tranquil blissful]
      },
      physical_indicators: %w[breathing deeply relaxed meditative]
    },
    'frustrated' => {
      synonyms: %w[exasperated aggravated annoyed blocked stuck],
      intensity_indicators: {
        low: %w[annoyed bothered],
        medium: %w[frustrated stuck],
        high: %w[exasperated aggravated]
      },
      physical_indicators: %w[sighing groaning head in hands]
    },
    'confused' => {
      synonyms: %w[puzzled perplexed bewildered lost uncertain unclear],
      intensity_indicators: {
        low: %w[uncertain unsure],
        medium: %w[confused puzzled],
        high: %w[bewildered perplexed lost]
      },
      physical_indicators: %w[scratching head frowning questioning]
    },
    'confident' => {
      synonyms: %w[sure certain assured self-assured determined ready],
      intensity_indicators: {
        low: %w[sure ready],
        medium: %w[confident certain],
        high: %w[unstoppable invincible]
      },
      physical_indicators: %w[standing tall shoulders back]
    }
  }.freeze
  
  # Emotional context patterns
  EMOTIONAL_CONTEXTS = {
    'work_stress' => %w[deadline pressure boss work project meeting],
    'relationship_joy' => %w[love partner family friend together],
    'achievement_pride' => %w[accomplished finished completed success won],
    'loss_grief' => %w[lost gone missing death goodbye],
    'future_anxiety' => %w[tomorrow later future worried scared],
    'health_concern' => %w[sick illness doctor medical pain],
    'financial_worry' => %w[money bills debt expensive cost],
    'creative_excitement' => %w[create making art writing music]
  }.freeze
  
  class << self
    def analyze_emotion(text, context = {})
      return default_emotion_analysis if text.blank?
      
      # Clean and prepare text
      clean_text = preprocess_text(text)
      
      # Multi-layer emotion analysis
      emotion_analysis = {
        primary_emotion: detect_primary_emotion(clean_text),
        secondary_emotions: detect_secondary_emotions(clean_text),
        intensity: calculate_emotional_intensity(clean_text),
        sentiment_score: calculate_sentiment_score(clean_text),
        emotional_context: identify_emotional_context(clean_text),
        confidence: calculate_confidence_score(clean_text),
        emotional_indicators: extract_emotional_indicators(clean_text),
        suggested_response_tone: suggest_response_tone(clean_text)
      }
      
      # Apply contextual adjustments
      emotion_analysis = apply_contextual_adjustments(emotion_analysis, context)
      
      emotion_analysis
    end
    
    def detect_emotional_transition(previous_emotion, current_emotion)
      return nil if previous_emotion == current_emotion
      
      transition = {
        from: previous_emotion,
        to: current_emotion,
        type: classify_transition_type(previous_emotion, current_emotion),
        significance: calculate_transition_significance(previous_emotion, current_emotion),
        recommended_acknowledgment: suggest_transition_acknowledgment(previous_emotion, current_emotion)
      }
      
      transition
    end
    
    def analyze_emotional_pattern(emotion_history)
      return {} if emotion_history.empty?
      
      pattern_analysis = {
        dominant_emotions: calculate_dominant_emotions(emotion_history),
        emotional_volatility: calculate_emotional_volatility(emotion_history),
        emotional_trends: identify_emotional_trends(emotion_history),
        trigger_patterns: identify_trigger_patterns(emotion_history),
        stability_indicators: assess_emotional_stability(emotion_history),
        recommendations: generate_emotional_recommendations(emotion_history)
      }
      
      pattern_analysis
    end
    
    def get_emotion_color_palette(emotion, intensity = 'medium')
      color_palettes = {
        'happy' => {
          low: ['#FFE066', '#FFF2A1'],
          medium: ['#FFD700', '#FFA500'],
          high: ['#FF6B35', '#FF4500']
        },
        'sad' => {
          low: ['#87CEEB', '#B0C4DE'],
          medium: ['#4682B4', '#5F9EA0'],
          high: ['#2F4F4F', '#363B74']
        },
        'angry' => {
          low: ['#FFA07A', '#FFB6C1'],
          medium: ['#FF6347', '#FF4500'],
          high: ['#DC143C', '#8B0000']
        },
        'anxious' => {
          low: ['#DDA0DD', '#E6E6FA'],
          medium: ['#9370DB', '#8A2BE2'],
          high: ['#4B0082', '#301934']
        },
        'excited' => {
          low: ['#FFB347', '#FFCCCB'],
          medium: ['#FF69B4', '#FF1493'],
          high: ['#FF00FF', '#DA70D6']
        },
        'calm' => {
          low: ['#E0FFFF', '#F0FFFF'],
          medium: ['#AFEEEE', '#87CEEB'],
          high: ['#5F9EA0', '#008B8B']
        },
        'frustrated' => {
          low: ['#F0E68C', '#BDB76B'],
          medium: ['#DAA520', '#B8860B'],
          high: ['#8B4513', '#A0522D']
        }
      }
      
      color_palettes.dig(emotion, intensity.to_sym) || ['#6B73FF', '#9FA8DA']
    end
    
    def suggest_emotional_support_strategy(emotion, intensity, context = {})
      strategy = {
        immediate_actions: get_immediate_support_actions(emotion, intensity),
        communication_approach: get_communication_approach(emotion),
        helpful_phrases: get_supportive_phrases(emotion),
        avoid_phrases: get_phrases_to_avoid(emotion),
        escalation_indicators: get_escalation_warning_signs(emotion, intensity),
        follow_up_suggestions: get_follow_up_suggestions(emotion)
      }
      
      strategy
    end
    
    private
    
    def default_emotion_analysis
      {
        primary_emotion: 'neutral',
        secondary_emotions: [],
        intensity: 5,
        sentiment_score: 0.0,
        emotional_context: 'general',
        confidence: 0.3,
        emotional_indicators: [],
        suggested_response_tone: 'balanced'
      }
    end
    
    def preprocess_text(text)
      # Basic text cleaning and normalization
      text.downcase
          .gsub(/[^\w\s]/, ' ')  # Remove punctuation
          .gsub(/\s+/, ' ')      # Normalize whitespace
          .strip
    end
    
    def detect_primary_emotion(text)
      emotion_scores = {}
      
      CORE_EMOTIONS.each do |emotion, data|
        score = 0
        
        # Check for direct emotion words
        if text.include?(emotion)
          score += 10
        end
        
        # Check for synonyms
        data[:synonyms].each do |synonym|
          if text.include?(synonym)
            score += 8
          end
        end
        
        # Check for intensity indicators
        data[:intensity_indicators].each do |intensity, words|
          words.each do |word|
            if text.include?(word)
              multiplier = case intensity
                          when :high then 3
                          when :medium then 2
                          when :low then 1
                          end
              score += 5 * multiplier
            end
          end
        end
        
        # Check for physical indicators
        data[:physical_indicators].each do |indicator|
          if text.include?(indicator)
            score += 6
          end
        end
        
        emotion_scores[emotion] = score if score > 0
      end
      
      # Return highest scoring emotion or neutral
      emotion_scores.empty? ? 'neutral' : emotion_scores.max_by { |_emotion, score| score }.first
    end
    
    def detect_secondary_emotions(text)
      emotion_scores = {}
      
      CORE_EMOTIONS.each do |emotion, data|
        score = 0
        
        # More lenient scoring for secondary emotions
        data[:synonyms].each do |synonym|
          score += 3 if text.include?(synonym)
        end
        
        emotion_scores[emotion] = score if score > 0
      end
      
      # Return emotions with score > 5, excluding primary
      emotion_scores.select { |_emotion, score| score >= 5 }
                   .sort_by { |_emotion, score| -score }
                   .first(2)
                   .map(&:first)
    end
    
    def calculate_emotional_intensity(text)
      intensity_indicators = {
        very_high: %w[extremely incredibly absolutely completely totally],
        high: %w[very really quite pretty much so],
        medium: %w[somewhat kinda little bit rather],
        low: %w[slightly barely hardly]
      }
      
      base_intensity = 5
      
      intensity_indicators.each do |level, words|
        words.each do |word|
          if text.include?(word)
            case level
            when :very_high then return 10
            when :high then return 8
            when :medium then return 6
            when :low then return 3
            end
          end
        end
      end
      
      # Look for capitalization as intensity indicator
      caps_ratio = text.scan(/[A-Z]/).length.to_f / text.length
      if caps_ratio > 0.3
        base_intensity += 2
      end
      
      # Look for exclamation marks
      exclamation_count = text.scan(/!/).length
      base_intensity += [exclamation_count, 3].min
      
      [base_intensity, 10].min
    end
    
    def calculate_sentiment_score(text)
      positive_words = %w[good great awesome amazing wonderful fantastic excellent love like enjoy happy]
      negative_words = %w[bad terrible awful horrible hate dislike sad angry frustrated disappointed]
      
      positive_score = positive_words.count { |word| text.include?(word) }
      negative_score = negative_words.count { |word| text.include?(word) }
      
      total_words = text.split.length
      return 0.0 if total_words == 0
      
      (positive_score - negative_score).to_f / total_words
    end
    
    def identify_emotional_context(text)
      context_scores = {}
      
      EMOTIONAL_CONTEXTS.each do |context, keywords|
        score = keywords.count { |keyword| text.include?(keyword) }
        context_scores[context] = score if score > 0
      end
      
      context_scores.empty? ? 'general' : context_scores.max_by { |_context, score| score }.first
    end
    
    def calculate_confidence_score(text)
      # Base confidence on multiple factors
      base_confidence = 0.5
      
      # Length factor - longer text generally more reliable
      length_factor = [text.length / 100.0, 1.0].min * 0.3
      
      # Emotion word density
      emotion_words = CORE_EMOTIONS.values.flat_map { |data| data[:synonyms] }
      emotion_density = emotion_words.count { |word| text.include?(word) }.to_f / text.split.length
      density_factor = [emotion_density * 2, 0.4].min
      
      final_confidence = base_confidence + length_factor + density_factor
      [final_confidence, 1.0].min.round(2)
    end
    
    def extract_emotional_indicators(text)
      indicators = []
      
      # Extract specific phrases that indicate emotion
      emotional_phrases = [
        /i feel (.*)/,
        /i am (.*)/,
        /this makes me (.*)/,
        /i'm so (.*)/,
        /i'm really (.*)/ 
      ]
      
      emotional_phrases.each do |pattern|
        matches = text.scan(pattern)
        indicators.concat(matches.flatten) if matches.any?
      end
      
      indicators.uniq.first(5)
    end
    
    def suggest_response_tone(text)
      emotion = detect_primary_emotion(text)
      intensity = calculate_emotional_intensity(text)
      
      case emotion
      when 'sad', 'anxious'
        intensity > 7 ? 'deeply_supportive' : 'gently_supportive'
      when 'angry', 'frustrated'
        intensity > 7 ? 'calming_and_validating' : 'understanding'
      when 'excited', 'happy'
        intensity > 7 ? 'enthusiastically_matching' : 'positively_encouraging'
      when 'confused'
        'clarifying_and_patient'
      when 'calm'
        'peacefully_present'
      else
        'balanced_and_adaptive'
      end
    end
    
    def apply_contextual_adjustments(analysis, context)
      # Adjust analysis based on additional context
      if context[:time_of_day] == 'late_night'
        # People tend to be more emotional late at night
        analysis[:intensity] = [analysis[:intensity] + 1, 10].min
      end
      
      if context[:conversation_history]&.any?
        # Consider previous emotional state
        previous_emotion = context[:conversation_history].last[:emotion]
        if previous_emotion && previous_emotion != analysis[:primary_emotion]
          analysis[:emotional_transition] = detect_emotional_transition(previous_emotion, analysis[:primary_emotion])
        end
      end
      
      analysis
    end
    
    def classify_transition_type(from_emotion, to_emotion)
      positive_emotions = %w[happy excited calm confident]
      negative_emotions = %w[sad angry anxious frustrated]
      
      from_positive = positive_emotions.include?(from_emotion)
      to_positive = positive_emotions.include?(to_emotion)
      
      case [from_positive, to_positive]
      when [true, true] then 'positive_shift'
      when [false, false] then 'negative_shift'
      when [false, true] then 'improvement'
      when [true, false] then 'decline'
      else 'neutral_shift'
      end
    end
    
    def calculate_transition_significance(from_emotion, to_emotion)
      # Emotional distance matrix (simplified)
      emotion_positions = {
        'happy' => [8, 8], 'excited' => [9, 7], 'calm' => [7, 9],
        'confident' => [8, 8], 'sad' => [2, 3], 'angry' => [3, 2],
        'anxious' => [2, 4], 'frustrated' => [4, 3], 'confused' => [5, 5]
      }
      
      from_pos = emotion_positions[from_emotion] || [5, 5]
      to_pos = emotion_positions[to_emotion] || [5, 5]
      
      # Calculate Euclidean distance
      distance = Math.sqrt((from_pos[0] - to_pos[0])**2 + (from_pos[1] - to_pos[1])**2)
      
      case distance
      when 0..2 then 'minor'
      when 2..5 then 'moderate'
      when 5..8 then 'significant'
      else 'major'
      end
    end
    
    def suggest_transition_acknowledgment(from_emotion, to_emotion)
      acknowledgments = {
        'improvement' => "I notice your mood has lifted! That's wonderful to see.",
        'decline' => "I sense your energy has shifted. That's completely normal.",
        'positive_shift' => "I love seeing this positive energy flow!",
        'negative_shift' => "I'm here with you through these feelings.",
        'neutral_shift' => "I notice your emotional energy has changed."
      }
      
      transition_type = classify_transition_type(from_emotion, to_emotion)
      acknowledgments[transition_type] || "I notice your emotional state has shifted."
    end
    
    # Emotional pattern analysis methods
    def calculate_dominant_emotions(emotion_history)
      emotion_counts = emotion_history.tally
      total_count = emotion_history.length
      
      emotion_counts.transform_values { |count| (count.to_f / total_count * 100).round(1) }
                   .sort_by { |_emotion, percentage| -percentage }
                   .first(3)
                   .to_h
    end
    
    def calculate_emotional_volatility(emotion_history)
      return 0 if emotion_history.length < 3
      
      transitions = emotion_history.each_cons(2).map do |prev, curr|
        prev != curr ? 1 : 0
      end
      
      (transitions.sum.to_f / transitions.length * 100).round(1)
    end
    
    def identify_emotional_trends(emotion_history)
      return {} if emotion_history.length < 5
      
      recent_half = emotion_history.last(emotion_history.length / 2)
      earlier_half = emotion_history.first(emotion_history.length / 2)
      
      recent_positivity = calculate_positivity_score(recent_half)
      earlier_positivity = calculate_positivity_score(earlier_half)
      
      trend = recent_positivity - earlier_positivity
      
      {
        direction: trend > 0.1 ? 'improving' : trend < -0.1 ? 'declining' : 'stable',
        magnitude: trend.abs.round(2),
        recent_positivity: recent_positivity,
        earlier_positivity: earlier_positivity
      }
    end
    
    def identify_trigger_patterns(_emotion_history)
      # Placeholder for trigger pattern analysis
      # Would analyze context around emotional spikes
      {}
    end
    
    def assess_emotional_stability(emotion_history)
      volatility = calculate_emotional_volatility(emotion_history)
      
      {
        stability_level: volatility < 20 ? 'high' : volatility < 50 ? 'moderate' : 'low',
        volatility_score: volatility,
        recommendations: generate_stability_recommendations(volatility)
      }
    end
    
    def generate_emotional_recommendations(emotion_history)
      recommendations = []
      
      dominant_emotions = calculate_dominant_emotions(emotion_history)
      volatility = calculate_emotional_volatility(emotion_history)
      
      if dominant_emotions.keys.first(2).any? { |emotion| %w[sad anxious].include?(emotion) }
        recommendations << "Consider practices that support emotional well-being"
      end
      
      if volatility > 60
        recommendations << "Emotional grounding techniques might be helpful"
      end
      
      if dominant_emotions['happy'] && dominant_emotions['happy'] > 60
        recommendations << "You're maintaining great emotional balance!"
      end
      
      recommendations
    end
    
    def calculate_positivity_score(emotions)
      positive_emotions = %w[happy excited calm confident]
      positive_count = emotions.count { |emotion| positive_emotions.include?(emotion) }
      
      positive_count.to_f / emotions.length
    end
    
    def generate_stability_recommendations(volatility)
      case volatility
      when 0..20
        ["Your emotional stability is excellent", "Continue your current practices"]
      when 20..50
        ["Consider mindfulness practices", "Regular emotional check-ins might help"]
      else
        ["Emotional grounding techniques recommended", "Consider professional support if needed"]
      end
    end
    
    # Support strategy methods
    def get_immediate_support_actions(emotion, intensity)
      actions = {
        'sad' => {
          low: ["Acknowledge the feeling", "Offer gentle presence"],
          medium: ["Provide comfort", "Listen actively", "Offer hope"],
          high: ["Immediate emotional support", "Check for safety", "Professional referral if needed"]
        },
        'anxious' => {
          low: ["Grounding techniques", "Reassurance"],
          medium: ["Breathing exercises", "Reality checking", "Calming presence"],
          high: ["Immediate grounding", "Crisis support", "Professional referral"]
        },
        'angry' => {
          low: ["Validate feelings", "Give space"],
          medium: ["Active listening", "Help process emotions", "Problem-solving support"],
          high: ["De-escalation", "Safety first", "Professional intervention"]
        }
      }
      
      intensity_level = intensity > 7 ? :high : intensity > 4 ? :medium : :low
      actions.dig(emotion, intensity_level) || ["Listen actively", "Provide support"]
    end
    
    def get_communication_approach(emotion)
      approaches = {
        'sad' => 'gentle and empathetic',
        'angry' => 'calm and validating',
        'anxious' => 'reassuring and grounding',
        'excited' => 'enthusiastic and matching energy',
        'confused' => 'clear and patient',
        'frustrated' => 'understanding and solution-focused'
      }
      
      approaches[emotion] || 'balanced and adaptive'
    end
    
    def get_supportive_phrases(emotion)
      phrases = {
        'sad' => [
          "I'm here with you", "Your feelings are valid", "This is temporary",
          "You're not alone", "It's okay to feel sad"
        ],
        'anxious' => [
          "You're safe right now", "Let's take this one step at a time",
          "Breathe with me", "You've handled difficult things before"
        ],
        'angry' => [
          "I hear your frustration", "Your anger makes sense",
          "Let's work through this together", "You have every right to feel this way"
        ]
      }
      
      phrases[emotion] || ["I'm here to support you", "Tell me more about how you're feeling"]
    end
    
    def get_phrases_to_avoid(emotion)
      avoid_phrases = {
        'sad' => [
          "Cheer up", "Look on the bright side", "Others have it worse",
          "Just think positive", "Get over it"
        ],
        'anxious' => [
          "Calm down", "Don't worry", "Just relax", "It's all in your head"
        ],
        'angry' => [
          "Calm down", "You're overreacting", "Just let it go", "Don't be so angry"
        ]
      }
      
      avoid_phrases[emotion] || ["You shouldn't feel that way", "Just ignore it"]
    end
    
    def get_escalation_warning_signs(emotion, intensity)
      warning_signs = {
        'sad' => intensity > 8 ? ["Hopelessness", "Isolation", "Self-harm mentions"] : [],
        'angry' => intensity > 8 ? ["Threats", "Violence", "Extreme language"] : [],
        'anxious' => intensity > 8 ? ["Panic symptoms", "Catastrophizing", "Avoidance"] : []
      }
      
      warning_signs[emotion] || []
    end
    
    def get_follow_up_suggestions(emotion)
      suggestions = {
        'sad' => ["Check in later", "Suggest self-care", "Offer continued support"],
        'anxious' => ["Practice grounding", "Regular check-ins", "Stress management"],
        'angry' => ["Process the situation", "Problem-solving", "Anger management techniques"]
      }
      
      suggestions[emotion] || ["Continue conversation", "Offer ongoing support"]
    end
  end
end
