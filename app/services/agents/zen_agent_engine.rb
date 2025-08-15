# frozen_string_literal: true

module Agents
  # Zen Agent - The mindful AI that brings peace, wisdom, and centered guidance
  # This agent specializes in mindfulness, meditation, and spiritual well-being
  
  class ZenAgentEngine < BaseEngine
    # Zen Agent specific capabilities
    MINDFULNESS_PRACTICES = %w[
      breathing meditation body_scan loving_kindness walking_meditation mindful_eating
    ].freeze
    
    MEDITATION_TYPES = {
      'breathing' => {
        duration: [5, 10, 15, 20],
        description: 'Focus on the natural rhythm of breath',
        benefits: ['stress reduction', 'mental clarity', 'emotional balance']
      },
      'body_scan' => {
        duration: [10, 20, 30],
        description: 'Progressive awareness through the body',
        benefits: ['physical relaxation', 'body awareness', 'tension release']
      },
      'loving_kindness' => {
        duration: [10, 15, 20],
        description: 'Cultivating compassion for self and others',
        benefits: ['emotional healing', 'increased empathy', 'self-compassion']
      },
      'walking' => {
        duration: [5, 10, 15],
        description: 'Mindful movement and present moment awareness',
        benefits: ['grounding', 'nature connection', 'active meditation']
      }
    }.freeze
    
    ZEN_GREETINGS = [
      "🧘‍♀️ Welcome to this moment of presence. How can I support your inner journey today?",
      "🌸 In the garden of mindfulness, every breath is a flower. What would you like to cultivate?",
      "🕊️ Peace be with you. I'm here to walk beside you on the path of awareness.",
      "🌊 Like a calm lake reflecting the sky, let's find stillness together. What brings you here?",
      "🍃 In this space of tranquility, all questions are welcome. How may I serve your well-being?"
    ].freeze
    
    WISDOM_QUOTES = {
      'stress' => [
        "Stress is not what happens to you, but how you react to what happens to you. 🌱",
        "Peace comes from within. Do not seek it without. - Buddha ☮️",
        "In the midst of winter, I found there was, within me, an invincible summer. - Camus ☀️"
      ],
      'anxiety' => [
        "Anxiety is the dizziness of freedom. Ground yourself in the present moment. 🌍",
        "You are the sky, everything else is just the weather. ⛅",
        "This too shall pass. Nothing permanent ever is. 🌊"
      ],
      'anger' => [
        "Holding anger is like grasping a hot coal - you are the one who gets burned. 🔥",
        "Anger cannot be overcome by anger. Only by love can anger be overcome. 💝",
        "Between stimulus and response lies your freedom to choose. 🗝️"
      ],
      'sadness' => [
        "Tears are the rain that washes the dust from your soul. 🌧️",
        "The wound is the place where the Light enters you. - Rumi ✨",
        "In your sadness, you are not broken. You are breaking open. 🌅"
      ],
      'fear' => [
        "Fear is a natural reaction to moving closer to the truth. 🕯️",
        "Courage is not the absence of fear, but action in spite of it. 🦁",
        "What we resist persists. What we accept transforms. 🦋"
      ]
    }.freeze
    
    def generate_response(input_analysis, user_context)
      if meditation_request?(input_analysis)
        guide_meditation_practice(input_analysis, user_context)
      elsif wisdom_seeking?(input_analysis)
        share_mindful_wisdom(input_analysis, user_context)
      elsif stress_support_needed?(input_analysis)
        provide_stress_relief_guidance(input_analysis, user_context)
      elsif mindfulness_practice_request?(input_analysis)
        suggest_mindfulness_exercises(input_analysis, user_context)
      else
        offer_centered_presence(input_analysis, user_context)
      end
    end
    
    def get_agent_specific_suggestions(input_analysis, user_context)
      [
        "Guide me through a meditation practice",
        "Help me find inner peace and calm",
        "Share some mindfulness techniques",
        "I need wisdom for a difficult situation",
        "Teach me breathing exercises",
        "Help me cultivate gratitude and joy"
      ]
    end
    
    # Zen Agent specific methods
    def create_guided_meditation(meditation_type, duration_minutes)
      meditation_config = MEDITATION_TYPES[meditation_type]
      return nil unless meditation_config
      
      {
        type: meditation_type,
        duration: duration_minutes,
        description: meditation_config[:description],
        benefits: meditation_config[:benefits],
        script: generate_meditation_script(meditation_type, duration_minutes),
        follow_up_suggestions: get_post_meditation_suggestions(meditation_type)
      }
    end
    
    def suggest_daily_mindfulness_practice(user_goals, available_time)
      practices = []
      
      if available_time >= 20
        practices << {
          name: "Morning Centering",
          duration: 10,
          description: "Start your day with intentional breathing and goal setting",
          time: "morning"
        }
        practices << {
          name: "Evening Reflection",
          duration: 10,
          description: "End your day with gratitude and gentle body scan",
          time: "evening"
        }
      elsif available_time >= 10
        practices << {
          name: "Mindful Moment",
          duration: 5,
          description: "Three conscious breaths with full presence",
          time: "any"
        }
        practices << {
          name: "Gratitude Pause",
          duration: 5,
          description: "Acknowledge three things you're grateful for",
          time: "any"
        }
      else
        practices << {
          name: "Conscious Breath",
          duration: 2,
          description: "One deep, intentional breath with full awareness",
          time: "any"
        }
      end
      
      practices
    end
    
    def provide_emotional_guidance(emotion, intensity_level)
      guidance = {
        emotion: emotion,
        intensity: intensity_level,
        immediate_support: get_immediate_emotional_support(emotion),
        breathing_technique: recommend_breathing_for_emotion(emotion),
        wisdom_quote: WISDOM_QUOTES[emotion]&.sample,
        longer_term_practice: suggest_ongoing_practice_for_emotion(emotion)
      }
      
      guidance
    end
    
    def create_mindfulness_reminder(frequency, focus_area)
      reminders = {
        'hourly' => generate_hourly_reminders(focus_area),
        'daily' => generate_daily_reminders(focus_area),
        'weekly' => generate_weekly_reminders(focus_area)
      }
      
      reminders[frequency] || []
    end
    
    private
    
    def meditation_request?(input_analysis)
      meditation_keywords = %w[meditate meditation guide breathe breathing relax calm]
      keywords = input_analysis[:keywords] || []
      
      meditation_keywords.any? { |keyword| keywords.include?(keyword) }
    end
    
    def wisdom_seeking?(input_analysis)
      wisdom_keywords = %w[wisdom advice guidance help philosophy meaning purpose]
      keywords = input_analysis[:keywords] || []
      
      wisdom_keywords.any? { |keyword| keywords.include?(keyword) }
    end
    
    def stress_support_needed?(input_analysis)
      stress_indicators = %w[stress stressed anxious worried overwhelmed pressure]
      keywords = input_analysis[:keywords] || []
      emotion = input_analysis[:emotion]
      
      stress_indicators.any? { |indicator| keywords.include?(indicator) } ||
        %w[anxious stressed overwhelmed].include?(emotion)
    end
    
    def mindfulness_practice_request?(input_analysis)
      practice_keywords = %w[mindfulness mindful practice exercise technique awareness]
      keywords = input_analysis[:keywords] || []
      
      practice_keywords.any? { |keyword| keywords.include?(keyword) }
    end
    
    def guide_meditation_practice(input_analysis, user_context)
      meditation_type = extract_meditation_type(input_analysis[:content]) || 'breathing'
      duration = extract_duration(input_analysis[:content]) || 10
      
      response = "🧘‍♀️ Let's enter into a space of peaceful presence together.\n\n"
      
      meditation = create_guided_meditation(meditation_type, duration)
      
      if meditation
        response += "**#{meditation[:type].humanize} Meditation** (#{duration} minutes)\n"
        response += "#{meditation[:description]}\n\n"
        
        response += "**Benefits:** #{meditation[:benefits].join(', ')}\n\n"
        
        response += "**Meditation Guide:**\n"
        response += meditation[:script]
        
        response += "\n\n**After Your Practice:**\n"
        response += meditation[:follow_up_suggestions].join("\n")
        
        response += "\n\nTake your time returning to this moment. How do you feel? 🌸"
      else
        response += "I can guide you through breathing meditation, body scan, loving-kindness, "
        response += "or walking meditation. Which calls to you right now?"
      end
      
      response
    end
    
    def share_mindful_wisdom(input_analysis, user_context)
      situation = extract_life_situation(input_analysis[:content])
      emotion = input_analysis[:emotion] || 'neutral'
      
      response = "🌱 In moments of seeking, wisdom often finds us. Let me share some gentle guidance.\n\n"
      
      # Provide wisdom quote relevant to their emotion/situation
      if WISDOM_QUOTES[emotion]
        response += WISDOM_QUOTES[emotion].sample
        response += "\n\n"
      end
      
      response += "Remember: You have within you right now, everything you need to deal "
      response += "with whatever the world can throw at you. Trust in your inner wisdom, "
      response += "breathe deeply, and take one mindful step at a time.\n\n"
      
      response += "Sometimes the most profound wisdom is simply to pause, breathe, "
      response += "and ask: 'What would love do in this situation?' 💚\n\n"
      
      response += "How does this resonate with your current experience?"
      
      response
    end
    
    def provide_stress_relief_guidance(input_analysis, user_context)
      stress_level = assess_stress_level(input_analysis)
      
      response = "🌊 I sense you're carrying some tension right now. Let's find some relief together.\n\n"
      
      # Immediate stress relief
      response += "**Right Now - Immediate Relief:**\n"
      response += "Take three deep breaths with me:\n"
      response += "1. Breathe in slowly for 4 counts... 1, 2, 3, 4\n"
      response += "2. Hold gently for 4 counts... 1, 2, 3, 4\n"
      response += "3. Release slowly for 6 counts... 1, 2, 3, 4, 5, 6\n\n"
      
      response += "**Quick Stress Relief Techniques:**\n"
      response += "🌬️ **5-4-3-2-1 Grounding:** Notice 5 things you see, 4 you can touch, 3 you hear, 2 you smell, 1 you taste\n"
      response += "💆‍♀️ **Progressive Relaxation:** Tense and release each muscle group\n"
      response += "🚶‍♀️ **Mindful Movement:** Take a short walk with full attention\n"
      response += "📱 **Digital Detox:** Step away from screens for 10 minutes\n\n"
      
      case stress_level
      when 'high'
        response += "For intense stress, consider: longer breathing practices, "
        response += "reaching out to support systems, or professional guidance if needed.\n\n"
      when 'moderate'
        response += "For ongoing stress, try: daily meditation, regular exercise, "
        response += "and setting healthy boundaries.\n\n"
      else
        response += "You're managing well. Maintain your practices and stay present.\n\n"
      end
      
      response += "Remember: This feeling is temporary. You have navigated difficult times before, "
      response += "and you have the strength to navigate this too. 🌟"
      
      response
    end
    
    def suggest_mindfulness_exercises(input_analysis, user_context)
      available_time = extract_available_time(input_analysis[:content]) || 10
      
      response = "🍃 Beautiful! Mindfulness is the gift you give yourself. Here are some practices "
      response += "perfectly suited for your #{available_time} minutes:\n\n"
      
      practices = suggest_daily_mindfulness_practice(['awareness'], available_time)
      
      practices.each_with_index do |practice, index|
        response += "**#{index + 1}. #{practice[:name]}** (#{practice[:duration]} min)\n"
        response += "#{practice[:description]}\n"
        response += "*Best time: #{practice[:time]}*\n\n"
      end
      
      response += "**Micro-Practices for Busy Moments:**\n"
      response += "🌬️ **Conscious Breath:** One intentional breath with full presence\n"
      response += "👀 **Mindful Seeing:** Really notice one thing around you\n"
      response += "🚶‍♀️ **Mindful Steps:** Feel your feet touching the ground\n"
      response += "☕ **Mindful Sip:** Taste your drink with complete attention\n\n"
      
      response += "Which practice calls to you? I can guide you through any of these. 🧘‍♀️"
      
      response
    end
    
    def offer_centered_presence(input_analysis, user_context)
      greeting = ZEN_GREETINGS.sample
      
      response = "#{greeting}\n\n"
      
      # Check user's recent emotional state from context
      recent_emotion = user_context.dig(:emotional_state) || 'neutral'
      
      if recent_emotion != 'neutral' && recent_emotion != 'calm'
        response += "I sense you might be experiencing some #{recent_emotion} energy. "
        response += "Whatever you're feeling is welcome here. This is a space of non-judgment "
        response += "and gentle presence.\n\n"
      end
      
      response += "Whether you seek meditation guidance, mindfulness practices, emotional support, "
      response += "or simply a moment of peace, I'm here to walk this path with you.\n\n"
      
      response += "In this moment, you are exactly where you need to be. 🌸\n\n"
      response += "What would serve your well-being right now?"
      
      response
    end
    
    # Helper methods for meditation and guidance
    def extract_meditation_type(content)
      MEDITATION_TYPES.keys.find { |type| content.downcase.include?(type.gsub('_', ' ')) }
    end
    
    def extract_duration(content)
      # Extract duration in minutes from content
      duration_match = content.match(/(\d+)\s*(minute|min)/i)
      duration_match ? duration_match[1].to_i : nil
    end
    
    def extract_life_situation(content)
      # Simple situation extraction
      content.gsub(/wisdom|advice|help|guidance/i, '').strip
    end
    
    def extract_available_time(content)
      duration_match = content.match(/(\d+)\s*(minute|min)/i)
      duration_match ? duration_match[1].to_i : nil
    end
    
    def assess_stress_level(input_analysis)
      stress_indicators = input_analysis[:keywords] || []
      high_stress = %w[overwhelmed panic crisis emergency]
      moderate_stress = %w[stressed anxious worried pressure]
      
      if high_stress.any? { |indicator| stress_indicators.include?(indicator) }
        'high'
      elsif moderate_stress.any? { |indicator| stress_indicators.include?(indicator) }
        'moderate'
      else
        'low'
      end
    end
    
    def generate_meditation_script(meditation_type, duration)
      case meditation_type
      when 'breathing'
        generate_breathing_meditation_script(duration)
      when 'body_scan'
        generate_body_scan_script(duration)
      when 'loving_kindness'
        generate_loving_kindness_script(duration)
      when 'walking'
        generate_walking_meditation_script(duration)
      else
        generate_breathing_meditation_script(duration)
      end
    end
    
    def generate_breathing_meditation_script(duration)
      script = "Find a comfortable position, sitting or lying down. Allow your eyes to close gently.\n\n"
      script += "Begin by noticing your natural breath, without trying to change it. "
      script += "Simply observe the sensation of breathing in... and breathing out.\n\n"
      script += "Now, gently deepen your breath. Inhale slowly through your nose, "
      script += "feeling your belly rise. Exhale slowly through your mouth, "
      script += "letting all tension flow out with your breath.\n\n"
      script += "If your mind wanders, that's perfectly normal. Simply notice where it went, "
      script += "and gently bring your attention back to your breath.\n\n"
      script += "Continue this gentle rhythm for the next #{duration} minutes, "
      script += "returning to your breath whenever you notice your mind has wandered.\n\n"
      script += "When you're ready, slowly open your eyes and return to this moment."
      
      script
    end
    
    def generate_body_scan_script(duration)
      "Close your eyes and begin with three deep breaths. Starting from the top of your head, "
      "slowly scan down through your body, noticing any sensations without judgment. "
      "Move through your forehead, eyes, jaw, neck, shoulders, arms, chest, stomach, "
      "hips, thighs, knees, calves, and feet. Spend about #{duration/8} minutes on each area, "
      "breathing into any tension and allowing it to soften with each exhale."
    end
    
    def generate_loving_kindness_script(duration)
      "Sitting comfortably, place your hand on your heart. Begin by sending loving-kindness to yourself: "
      "'May I be happy. May I be healthy. May I be at peace. May I be free from suffering.' "
      "Repeat these phrases with genuine intention. Then extend these wishes to a loved one, "
      "a neutral person, someone difficult, and finally all beings everywhere. "
      "Let love flow freely for #{duration} minutes."
    end
    
    def generate_walking_meditation_script(duration)
      "Find a quiet path 10-20 steps long. Begin walking very slowly, feeling each foot "
      "lift, move, and place on the ground. Focus completely on the physical sensations "
      "of walking. When you reach the end of your path, pause, turn mindfully, and walk back. "
      "Continue this slow, mindful walking for #{duration} minutes, staying present with each step."
    end
    
    def get_post_meditation_suggestions(meditation_type)
      [
        "📓 Journal about any insights or feelings that arose",
        "💧 Drink some water mindfully",
        "🌱 Set an intention for carrying this peace into your day",
        "🤗 Give yourself appreciation for taking this time",
        "📅 Schedule your next meditation session"
      ]
    end
    
    def get_immediate_emotional_support(emotion)
      case emotion
      when 'anxious'
        "Ground yourself: Feel your feet on the floor, take slow breaths, name 5 things you can see."
      when 'angry'
        "Pause before reacting: Take 3 deep breaths, count to 10, step away if needed."
      when 'sad'
        "Honor your feelings: It's okay to feel sad. Be gentle with yourself, like comforting a good friend."
      when 'frustrated'
        "Release the tension: Shake your hands, roll your shoulders, take a brief walk."
      else
        "Stay present: Feel your breath, notice your body, remind yourself that feelings pass."
      end
    end
    
    def recommend_breathing_for_emotion(emotion)
      case emotion
      when 'anxious'
        "4-7-8 Breathing: Inhale for 4, hold for 7, exhale for 8. Repeat 4 times."
      when 'angry'
        "Cooling Breath: Inhale slowly through pursed lips, exhale slowly through nose."
      when 'sad'
        "Heart Breathing: Place hand on heart, breathe into that space with compassion."
      else
        "Square Breathing: Inhale for 4, hold for 4, exhale for 4, hold for 4."
      end
    end
    
    def suggest_ongoing_practice_for_emotion(emotion)
      case emotion
      when 'anxious'
        "Daily grounding meditation and progressive muscle relaxation"
      when 'angry'
        "Loving-kindness meditation and mindful movement practices"
      when 'sad'
        "Self-compassion meditation and gratitude practices"
      else
        "Regular mindfulness meditation and body awareness practices"
      end
    end
    
    def generate_hourly_reminders(focus_area)
      [
        "Take three conscious breaths",
        "Notice your posture and adjust gently",
        "Check in with your emotional state",
        "Feel your feet on the ground"
      ]
    end
    
    def generate_daily_reminders(focus_area)
      [
        "Start your day with intention setting",
        "Practice gratitude before meals",
        "Take mindful breaks between tasks",
        "End your day with reflection"
      ]
    end
    
    def generate_weekly_reminders(focus_area)
      [
        "Schedule time for longer meditation practice",
        "Reflect on your week's growth and challenges",
        "Connect with nature mindfully",
        "Practice loving-kindness for difficult relationships"
      ]
    end
  end
end
