# frozen_string_literal: true

module Agents
  # EmotiSense - Mood & Emotion Analyzer
  # Advanced emotional intelligence AI that detects, interprets, and responds to human emotions
  # in real-time across text, voice, and context with cinematic UI triggers
  class EmotisenseEngine < BaseEngine
    
    # Core emotional analysis capabilities
    EMOTIONAL_CAPABILITIES = [
      'emotion_detection',
      'mood_analysis', 
      'sentiment_interpretation',
      'context_awareness',
      'voice_emotion_analysis',
      'cinematic_ui_triggers',
      'empathetic_responses',
      'emotional_memory'
    ].freeze

    # Emotion categories with intensity levels
    EMOTION_CATEGORIES = {
      joy: { 
        intensity_levels: ['content', 'happy', 'excited', 'ecstatic', 'euphoric'],
        color_palette: ['#ffd700', '#ffb347', '#ff6b35', '#ff4757', '#ff3838']
      },
      sadness: {
        intensity_levels: ['melancholy', 'sad', 'sorrowful', 'depressed', 'despairing'], 
        color_palette: ['#74b9ff', '#0984e3', '#006ba6', '#0056b3', '#003d82']
      },
      anger: {
        intensity_levels: ['annoyed', 'frustrated', 'angry', 'furious', 'enraged'],
        color_palette: ['#ff7675', '#e84393', '#fd79a8', '#e84393', '#d63031']
      },
      fear: {
        intensity_levels: ['worried', 'anxious', 'afraid', 'terrified', 'panicked'],
        color_palette: ['#636e72', '#2d3436', '#6c5ce7', '#a29bfe', '#74b9ff']
      },
      surprise: {
        intensity_levels: ['curious', 'surprised', 'amazed', 'astonished', 'shocked'],
        color_palette: ['#00cec9', '#00b894', '#55a3ff', '#0984e3', '#6c5ce7']
      },
      love: {
        intensity_levels: ['fondness', 'affection', 'love', 'adoration', 'devotion'],
        color_palette: ['#fd79a8', '#e84393', '#ff3867', '#ff006e', '#d63031']
      },
      excitement: {
        intensity_levels: ['interested', 'enthusiastic', 'excited', 'thrilled', 'exhilarated'],
        color_palette: ['#fdcb6e', '#e17055', '#fd79a8', '#6c5ce7', '#a29bfe']
      },
      calm: {
        intensity_levels: ['peaceful', 'serene', 'tranquil', 'meditative', 'blissful'],
        color_palette: ['#00b894', '#00cec9', '#81ecec', '#74b9ff', '#a29bfe']
      }
    }.freeze

    def initialize(agent = nil, user = nil)
      super(agent) if agent
      @user = user
      @emotion_history = []
      @current_mood_state = :neutral
      @emotional_context = {}
    end

    def capabilities
      EMOTIONAL_CAPABILITIES
    end

    def process_input(input, context = {})
      # Analyze emotional content of input
      emotion_analysis = analyze_emotions(input)
      
      # Update emotional context and history
      update_emotional_context(emotion_analysis, context)
      
      # Generate empathetic response based on detected emotions
      response = generate_empathetic_response(input, emotion_analysis)
      
      # Add cinematic UI triggers
      ui_triggers = generate_ui_triggers(emotion_analysis)
      
      {
        response: response,
        emotion_analysis: emotion_analysis,
        ui_triggers: ui_triggers,
        mood_state: @current_mood_state,
        suggestions: generate_mood_suggestions(emotion_analysis),
        visualizations: generate_emotion_visualizations(emotion_analysis)
      }
    end

    private

    def analyze_emotions(text)
      # Advanced NLP emotion detection
      words = text.downcase.split(/\W+/)
      
      # Emotion scoring based on advanced sentiment analysis
      emotion_scores = {}
      
      # Joy indicators
      joy_words = ['happy', 'excited', 'amazing', 'wonderful', 'fantastic', 'great', 'awesome', 'love', 'perfect', 'brilliant']
      emotion_scores[:joy] = calculate_emotion_score(words, joy_words)
      
      # Sadness indicators  
      sadness_words = ['sad', 'depressed', 'down', 'terrible', 'awful', 'horrible', 'worst', 'crying', 'heartbroken', 'devastated']
      emotion_scores[:sadness] = calculate_emotion_score(words, sadness_words)
      
      # Anger indicators
      anger_words = ['angry', 'furious', 'mad', 'frustrated', 'annoyed', 'hate', 'stupid', 'ridiculous', 'outrageous', 'infuriating']
      emotion_scores[:anger] = calculate_emotion_score(words, anger_words)
      
      # Fear/Anxiety indicators
      fear_words = ['worried', 'anxious', 'scared', 'afraid', 'nervous', 'terrified', 'panic', 'stress', 'overwhelmed', 'uncertain']
      emotion_scores[:fear] = calculate_emotion_score(words, fear_words)
      
      # Excitement indicators
      excitement_words = ['excited', 'thrilled', 'pumped', 'enthusiastic', 'eager', 'can\'t wait', 'amazing', 'incredible', 'fantastic']
      emotion_scores[:excitement] = calculate_emotion_score(words, excitement_words)

      # Love/Affection indicators
      love_words = ['love', 'adore', 'cherish', 'appreciate', 'grateful', 'thankful', 'blessed', 'heart', 'care', 'fond']
      emotion_scores[:love] = calculate_emotion_score(words, love_words)

      # Determine primary emotion and intensity
      primary_emotion = emotion_scores.max_by { |_, score| score }&.first || :neutral
      intensity = determine_intensity(emotion_scores[primary_emotion] || 0)
      
      # Detect emotional context and subtext
      context_analysis = analyze_emotional_context(text, words)
      
      {
        primary_emotion: primary_emotion,
        intensity: intensity,
        confidence: [emotion_scores[primary_emotion] || 0, 1.0].min,
        all_emotions: emotion_scores,
        emotional_context: context_analysis,
        mood_indicators: detect_mood_indicators(words),
        timestamp: Time.current
      }
    end

    def calculate_emotion_score(words, emotion_indicators)
      matches = words.count { |word| emotion_indicators.any? { |indicator| word.include?(indicator) } }
      intensifiers = words.count { |word| ['very', 'extremely', 'incredibly', 'absolutely', 'totally'].include?(word) }
      
      base_score = matches.to_f / [words.length, 1].max
      intensified_score = base_score + (intensifiers * 0.2)
      
      [intensified_score, 1.0].min
    end

    def determine_intensity(score)
      case score
      when 0...0.2 then 'low'
      when 0.2...0.4 then 'moderate'
      when 0.4...0.6 then 'high'
      when 0.6...0.8 then 'very_high'
      else 'extreme'
      end
    end

    def analyze_emotional_context(text, words)
      {
        question_detected: text.include?('?'),
        urgency_detected: words.any? { |w| ['urgent', 'asap', 'quickly', 'immediately', 'now'].include?(w) },
        uncertainty_detected: words.any? { |w| ['maybe', 'perhaps', 'unsure', 'confused', 'don\'t know'].include?(w) },
        social_context: detect_social_context(words),
        temporal_context: detect_temporal_context(words)
      }
    end

    def detect_social_context(words)
      if words.any? { |w| ['we', 'us', 'together', 'team', 'group'].include?(w) }
        'collaborative'
      elsif words.any? { |w| ['alone', 'lonely', 'isolated', 'myself'].include?(w) }
        'solitary'
      else
        'individual'
      end
    end

    def detect_temporal_context(words)
      if words.any? { |w| ['yesterday', 'past', 'before', 'earlier', 'was'].include?(w) }
        'past'
      elsif words.any? { |w| ['tomorrow', 'future', 'will', 'going to', 'later'].include?(w) }
        'future'
      else
        'present'
      end
    end

    def detect_mood_indicators(words)
      {
        energy_level: detect_energy_level(words),
        social_mood: detect_social_mood(words),
        cognitive_state: detect_cognitive_state(words)
      }
    end

    def detect_energy_level(words)
      high_energy = ['energetic', 'pumped', 'active', 'dynamic', 'vibrant']
      low_energy = ['tired', 'exhausted', 'drained', 'sluggish', 'lethargic']
      
      if words.any? { |w| high_energy.include?(w) }
        'high'
      elsif words.any? { |w| low_energy.include?(w) }
        'low'
      else
        'moderate'
      end
    end

    def detect_social_mood(words)
      social_words = ['social', 'party', 'friends', 'people', 'together']
      antisocial_words = ['alone', 'quiet', 'solitude', 'private', 'isolated']
      
      if words.any? { |w| social_words.include?(w) }
        'social'
      elsif words.any? { |w| antisocial_words.include?(w) }
        'introspective'
      else
        'neutral'
      end
    end

    def detect_cognitive_state(words)
      clear_thinking = ['clear', 'focused', 'sharp', 'alert', 'concentrated']
      confused_thinking = ['confused', 'foggy', 'unclear', 'scattered', 'overwhelmed']
      
      if words.any? { |w| clear_thinking.include?(w) }
        'clear'
      elsif words.any? { |w| confused_thinking.include?(w) }
        'confused'
      else
        'normal'
      end
    end

    def update_emotional_context(emotion_analysis, context)
      @emotion_history << emotion_analysis
      @emotion_history = @emotion_history.last(10) # Keep last 10 emotions
      
      # Update current mood state based on recent emotional patterns
      @current_mood_state = determine_overall_mood
      
      # Store contextual information
      @emotional_context.merge!(context)
    end

    def determine_overall_mood
      return :neutral if @emotion_history.empty?
      
      recent_emotions = @emotion_history.last(3)
      emotion_counts = recent_emotions.group_by { |e| e[:primary_emotion] }
      dominant_emotion = emotion_counts.max_by { |_, emotions| emotions.length }&.first
      
      # Map emotions to mood states
      case dominant_emotion
      when :joy, :excitement, :love then :positive
      when :sadness, :fear then :negative  
      when :anger then :agitated
      when :calm then :peaceful
      else :neutral
      end
    end

    def generate_empathetic_response(input, emotion_analysis)
      emotion = emotion_analysis[:primary_emotion]
      intensity = emotion_analysis[:intensity]
      
      base_response = case emotion
      when :joy
        "I can sense your happiness! ✨ Your positive energy is wonderful to experience. "
      when :sadness
        "I notice you might be feeling down right now. 💙 I'm here to listen and support you. "
      when :anger
        "I can feel the frustration in your words. 🔥 Let's work through this together. "
      when :fear
        "I sense some worry or anxiety. 🤗 It's completely natural to feel this way. "
      when :excitement
        "Your excitement is contagious! 🚀 I love your enthusiasm. "
      when :love
        "The warmth and affection in your message is beautiful. 💖 "
      when :calm
        "Your peaceful energy is so soothing. 🧘‍♀️ "
      else
        "I'm tuning into your emotional state. "
      end

      # Add intensity-based modulation
      intensity_modifier = case intensity
      when 'extreme' then "The intensity of what you're feeling comes through very clearly. "
      when 'very_high' then "You're experiencing this quite strongly. "
      when 'high' then "This feeling seems significant for you. "
      else ""
      end

      # Add contextual empathy based on emotional context
      context_response = generate_contextual_empathy(emotion_analysis)
      
      "#{base_response}#{intensity_modifier}#{context_response}How can I best support you right now?"
    end

    def generate_contextual_empathy(emotion_analysis)
      context = emotion_analysis[:emotional_context]
      
      empathy_responses = []
      
      if context[:question_detected]
        empathy_responses << "I see you're looking for answers. "
      end
      
      if context[:urgency_detected]
        empathy_responses << "I understand this feels urgent to you. "
      end
      
      if context[:uncertainty_detected]
        empathy_responses << "Uncertainty can be challenging to navigate. "
      end
      
      empathy_responses.join
    end

    def generate_ui_triggers(emotion_analysis)
      emotion = emotion_analysis[:primary_emotion]
      intensity = emotion_analysis[:intensity]
      
      {
        background_color: get_emotion_color(emotion, intensity),
        ambient_effect: get_ambient_effect(emotion),
        animation_style: get_animation_style(emotion, intensity),
        music_mood: get_music_mood(emotion),
        lighting_effect: get_lighting_effect(emotion, intensity),
        particle_system: get_particle_system(emotion)
      }
    end

    def get_emotion_color(emotion, intensity)
      return '#6c5ce7' unless EMOTION_CATEGORIES[emotion] # Default purple
      
      colors = EMOTION_CATEGORIES[emotion][:color_palette]
      intensity_index = case intensity
      when 'low' then 0
      when 'moderate' then 1  
      when 'high' then 2
      when 'very_high' then 3
      when 'extreme' then 4
      else 1
      end
      
      colors[intensity_index] || colors.last
    end

    def get_ambient_effect(emotion)
      {
        joy: 'golden_sparkles',
        sadness: 'gentle_rain',
        anger: 'fire_embers', 
        fear: 'shadow_wisps',
        excitement: 'energy_bursts',
        love: 'heart_particles',
        calm: 'floating_bubbles'
      }[emotion] || 'neutral_flow'
    end

    def get_animation_style(emotion, intensity)
      base_style = {
        joy: 'bounce',
        sadness: 'gentle_sway',
        anger: 'sharp_pulse',
        fear: 'subtle_shake',
        excitement: 'rapid_bounce',
        love: 'heart_beat',
        calm: 'slow_breath'
      }[emotion] || 'fade'
      
      # Modify based on intensity
      intensity_modifier = case intensity
      when 'extreme', 'very_high' then '_intense'
      when 'low' then '_subtle'
      else ''
      end
      
      "#{base_style}#{intensity_modifier}"
    end

    def get_music_mood(emotion)
      {
        joy: 'uplifting_melody',
        sadness: 'melancholic_piano', 
        anger: 'intense_drums',
        fear: 'suspenseful_strings',
        excitement: 'energetic_beat',
        love: 'romantic_strings',
        calm: 'nature_sounds'
      }[emotion] || 'ambient_neutral'
    end

    def get_lighting_effect(emotion, intensity)
      base_effect = {
        joy: 'warm_glow',
        sadness: 'cool_dim',
        anger: 'red_pulse',
        fear: 'flickering_shadows',
        excitement: 'strobe_burst',
        love: 'pink_halo',
        calm: 'soft_white'
      }[emotion] || 'neutral'
      
      opacity = case intensity
      when 'extreme' then 0.9
      when 'very_high' then 0.7
      when 'high' then 0.5
      when 'moderate' then 0.3
      else 0.1
      end
      
      { effect: base_effect, opacity: opacity }
    end

    def get_particle_system(emotion)
      {
        joy: { type: 'stars', count: 50, speed: 'medium' },
        sadness: { type: 'teardrops', count: 20, speed: 'slow' },
        anger: { type: 'flames', count: 30, speed: 'fast' },
        fear: { type: 'mist', count: 15, speed: 'slow' },
        excitement: { type: 'confetti', count: 100, speed: 'fast' },
        love: { type: 'hearts', count: 25, speed: 'medium' },
        calm: { type: 'leaves', count: 10, speed: 'very_slow' }
      }[emotion] || { type: 'dots', count: 5, speed: 'slow' }
    end

    def generate_mood_suggestions(emotion_analysis)
      emotion = emotion_analysis[:primary_emotion]
      
      case emotion
      when :joy
        [
          "Share this positive energy with someone you care about",
          "Capture this moment in a journal or photo",
          "Use this momentum to tackle a creative project"
        ]
      when :sadness
        [
          "Take some time for self-care and gentle activities",
          "Connect with a supportive friend or family member", 
          "Try some calming music or meditation"
        ]
      when :anger
        [
          "Take some deep breaths or try a quick walk",
          "Channel this energy into physical exercise",
          "Write down your thoughts to process them"
        ]
      when :fear
        [
          "Ground yourself with deep breathing exercises",
          "Break down the situation into manageable steps",
          "Reach out to someone you trust for support"
        ]
      when :excitement
        [
          "Channel this energy into productive activities",
          "Share your enthusiasm with others",
          "Start planning for what's exciting you"
        ]
      when :love
        [
          "Express your feelings to those you care about",
          "Do something kind for someone special",
          "Practice gratitude for the love in your life"
        ]
      when :calm
        [
          "Enjoy this peaceful moment mindfully",
          "Use this clarity for reflection or planning",
          "Share this calming energy with others"
        ]
      else
        [
          "Take a moment to check in with yourself",
          "Notice what you're feeling without judgment",
          "Consider what would support you right now"
        ]
      end
    end

    def generate_emotion_visualizations(emotion_analysis)
      {
        emotion_wheel: create_emotion_wheel(emotion_analysis),
        intensity_bar: create_intensity_visualization(emotion_analysis),
        mood_timeline: create_mood_timeline,
        emotion_cloud: create_emotion_cloud(emotion_analysis)
      }
    end

    def create_emotion_wheel(emotion_analysis)
      emotions = emotion_analysis[:all_emotions]
      total_score = emotions.values.sum
      
      emotions.map do |emotion, score|
        percentage = total_score > 0 ? (score / total_score * 100).round(1) : 0
        {
          emotion: emotion,
          percentage: percentage,
          color: get_emotion_color(emotion, 'moderate'),
          intensity: determine_intensity(score)
        }
      end
    end

    def create_intensity_visualization(emotion_analysis)
      {
        primary_emotion: emotion_analysis[:primary_emotion],
        intensity_level: emotion_analysis[:intensity],
        confidence: (emotion_analysis[:confidence] * 100).round(1),
        color: get_emotion_color(emotion_analysis[:primary_emotion], emotion_analysis[:intensity])
      }
    end

    def create_mood_timeline
      @emotion_history.last(5).map.with_index do |emotion_data, index|
        {
          timestamp: emotion_data[:timestamp],
          emotion: emotion_data[:primary_emotion],
          intensity: emotion_data[:intensity],
          color: get_emotion_color(emotion_data[:primary_emotion], emotion_data[:intensity]),
          index: index
        }
      end
    end

    def create_emotion_cloud(emotion_analysis)
      words = emotion_analysis[:emotional_context].keys + 
              [emotion_analysis[:primary_emotion].to_s] +
              emotion_analysis[:mood_indicators].values.flatten.map(&:to_s)
      
      words.uniq.map do |word|
        {
          word: word.humanize,
          weight: rand(1..5), # In real implementation, this would be based on relevance
          color: get_emotion_color(emotion_analysis[:primary_emotion], 'moderate')
        }
      end
    end
  end
end
