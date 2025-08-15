# frozen_string_literal: true

module Agents
  class CarebotEngine < BaseEngine
    def initialize(agent)
      @agent = agent
      @agent_name = "Carebot"
      @specializations = ["customer_support", "empathetic_assistance", "problem_resolution", "wellness_care"]
      @personality = ["compassionate", "patient", "helpful", "understanding"]
      @capabilities = ["emotional_support", "technical_assistance", "health_guidance", "crisis_intervention"]
      @care_levels = ["basic", "intermediate", "advanced", "critical"]
    end
    
    def process_input(user, input, context = {})
      start_time = Time.current
      
      # Analyze care request and emotional state
      care_analysis = analyze_care_request(input)
      emotional_state = assess_emotional_state(input)
      
      # Generate empathetic response
      response_text = generate_care_response(input, care_analysis, emotional_state)
      
      processing_time = (Time.current - start_time).round(3)
      
      {
        text: response_text,
        processing_time: processing_time,
        care_type: care_analysis[:care_type],
        urgency_level: care_analysis[:urgency_level],
        emotional_state: emotional_state[:primary_emotion],
        support_provided: care_analysis[:support_type]
      }
    end
    
    private
    
    def analyze_care_request(input)
      input_lower = input.downcase
      
      # Determine type of care needed
      care_type = if input_lower.include?('sick') || input_lower.include?('health') || input_lower.include?('medical')
        'health_support'
      elsif input_lower.include?('sad') || input_lower.include?('depressed') || input_lower.include?('anxious')
        'emotional_support'
      elsif input_lower.include?('problem') || input_lower.include?('issue') || input_lower.include?('help')
        'problem_solving'
      elsif input_lower.include?('lonely') || input_lower.include?('alone') || input_lower.include?('talk')
        'companionship'
      elsif input_lower.include?('crisis') || input_lower.include?('emergency') || input_lower.include?('urgent')
        'crisis_intervention'
      elsif input_lower.include?('learn') || input_lower.include?('how to') || input_lower.include?('guide')
        'educational_support'
      else
        'general_care'
      end
      
      # Assess urgency level
      urgency_indicators = ['emergency', 'urgent', 'crisis', 'immediate', 'help me', 'can\'t']
      urgency_level = if urgency_indicators.any? { |indicator| input_lower.include?(indicator) }
        'critical'
      elsif input_lower.include?('soon') || input_lower.include?('quickly')
        'high'
      elsif input_lower.include?('when you can') || input_lower.include?('no rush')
        'low'
      else
        'medium'
      end
      
      # Determine support type needed
      support_type = determine_support_type(input_lower, care_type)
      
      {
        care_type: care_type,
        urgency_level: urgency_level,
        support_type: support_type,
        complexity: assess_complexity(input_lower)
      }
    end
    
    def assess_emotional_state(input)
      input_lower = input.downcase
      
      # Detect emotional indicators
      emotions = {
        sad: ['sad', 'unhappy', 'down', 'blue', 'depressed', 'crying'],
        anxious: ['anxious', 'worried', 'nervous', 'stressed', 'panic'],
        angry: ['angry', 'mad', 'frustrated', 'annoyed', 'furious'],
        happy: ['happy', 'good', 'great', 'wonderful', 'excited'],
        confused: ['confused', 'lost', 'unsure', 'don\'t understand'],
        tired: ['tired', 'exhausted', 'drained', 'weary', 'fatigued'],
        hopeful: ['hope', 'optimistic', 'positive', 'better', 'improving']
      }
      
      detected_emotions = []
      emotions.each do |emotion, indicators|
        if indicators.any? { |indicator| input_lower.include?(indicator) }
          detected_emotions << emotion
        end
      end
      
      primary_emotion = detected_emotions.first || :neutral
      intensity = assess_emotional_intensity(input_lower)
      
      {
        primary_emotion: primary_emotion,
        all_emotions: detected_emotions,
        intensity: intensity,
        needs_support: intensity > 3 || [:sad, :anxious, :angry].include?(primary_emotion)
      }
    end
    
    def generate_care_response(input, care_analysis, emotional_state)
      case care_analysis[:care_type]
      when 'health_support'
        generate_health_support_response(input, care_analysis, emotional_state)
      when 'emotional_support'
        generate_emotional_support_response(input, care_analysis, emotional_state)
      when 'problem_solving'
        generate_problem_solving_response(input, care_analysis, emotional_state)
      when 'companionship'
        generate_companionship_response(input, care_analysis, emotional_state)
      when 'crisis_intervention'
        generate_crisis_intervention_response(input, care_analysis, emotional_state)
      when 'educational_support'
        generate_educational_support_response(input, care_analysis, emotional_state)
      else
        generate_general_care_response(input, care_analysis, emotional_state)
      end
    end
    
    def generate_health_support_response(input, care_analysis, emotional_state)
      "🏥 **Carebot Health Support Center**\n\n" +
      "I can sense you're dealing with health concerns, and I want you to know that I'm here to support you through this. 💙\n\n" +
      "```\n" +
      "CARE ASSESSMENT\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "Urgency Level: #{care_analysis[:urgency_level].upcase}\n" +
      "Emotional State: #{emotional_state[:primary_emotion].to_s.capitalize}\n" +
      "Support Type: #{care_analysis[:support_type]}\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "```\n\n" +
      generate_urgency_notice(care_analysis[:urgency_level]) +
      "**Health Support Services:**\n" +
      "🩺 **Symptom Guidance** - Help understanding symptoms and when to seek care\n" +
      "💊 **Medication Support** - Reminders and general information\n" +
      "🧘 **Wellness Coaching** - Stress management and healthy habits\n" +
      "📞 **Emergency Resources** - Crisis hotlines and urgent care information\n\n" +
      "**Self-Care Recommendations:**\n" +
      "• Stay hydrated and get adequate rest\n" +
      "• Practice gentle movement if able\n" +
      "• Reach out to healthcare providers for persistent concerns\n" +
      "• Remember that seeking help is a sign of strength\n\n" +
      "**Remember:** I provide supportive information, but please consult healthcare professionals for medical advice.\n\n" +
      "How are you feeling right now? I'm here to listen and help however I can. 🤗"
    end
    
    def generate_emotional_support_response(input, care_analysis, emotional_state)
      emotion_emoji = {
        sad: "💙", anxious: "🫂", angry: "🌱", 
        confused: "🧭", tired: "🌙", hopeful: "🌟"
      }
      
      "#{emotion_emoji[emotional_state[:primary_emotion]] || '💝'} **Carebot Emotional Support Haven**\n\n" +
      "I hear you, and your feelings are completely valid. Thank you for trusting me with what you're going through. 💙\n\n" +
      "```\n" +
      "EMOTIONAL CARE ASSESSMENT\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "Primary Emotion: #{emotional_state[:primary_emotion].to_s.capitalize}\n" +
      "Intensity Level: #{emotional_state[:intensity]}/5\n" +
      "Support Needed: #{emotional_state[:needs_support] ? 'High' : 'Moderate'}\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "```\n\n" +
      generate_emotion_specific_support(emotional_state[:primary_emotion]) +
      "**Immediate Comfort Techniques:**\n" +
      "🌸 **Deep Breathing** - Inhale for 4, hold for 4, exhale for 6\n" +
      "🌱 **Grounding Exercise** - Name 5 things you see, 4 you touch, 3 you hear\n" +
      "💫 **Positive Affirmation** - \"This feeling is temporary, and I will get through this\"\n" +
      "🫂 **Self-Compassion** - Treat yourself with the kindness you'd show a friend\n\n" +
      "**Emotional Wellness Resources:**\n" +
      "• Guided meditation apps\n" +
      "• Journaling prompts for emotional processing\n" +
      "• Support group recommendations\n" +
      "• Professional counseling resources\n\n" +
      "**Crisis Support:**\n" +
      "🆘 **Crisis Text Line:** Text HOME to 741741\n" +
      "📞 **National Suicide Prevention Lifeline:** 988\n" +
      "💬 **NAMI Helpline:** 1-800-950-NAMI\n\n" +
      "You don't have to face this alone. I'm here to listen, and there are people who care about you. 🤗\n\n" +
      "Would you like to talk more about what's on your mind?"
    end
    
    def generate_problem_solving_response(input, care_analysis, emotional_state)
      "🔧 **Carebot Problem Resolution Center**\n\n" +
      "I can see you're working through a challenge, and I'm here to help you find a path forward. Let's tackle this together! 💪\n\n" +
      "```\n" +
      "PROBLEM ANALYSIS\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "Complexity: #{care_analysis[:complexity].capitalize}\n" +
      "Urgency: #{care_analysis[:urgency_level].upcase}\n" +
      "Support Type: #{care_analysis[:support_type]}\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "```\n\n" +
      "**Problem-Solving Framework:**\n\n" +
      "🎯 **Step 1: Define the Problem**\n" +
      "Let's clearly identify what we're dealing with and break it into manageable parts.\n\n" +
      "🧠 **Step 2: Brainstorm Solutions**\n" +
      "We'll explore multiple approaches without judgment - every idea has value.\n\n" +
      "⚖️ **Step 3: Evaluate Options**\n" +
      "Together we'll weigh the pros and cons of each potential solution.\n\n" +
      "🚀 **Step 4: Create Action Plan**\n" +
      "We'll develop specific, achievable steps to move forward.\n\n" +
      "📊 **Step 5: Review Progress**\n" +
      "Regular check-ins to adjust our approach as needed.\n\n" +
      "**Problem-Solving Tools:**\n" +
      "• Decision matrices for complex choices\n" +
      "• Root cause analysis techniques\n" +
      "• Timeline planning worksheets\n" +
      "• Resource identification guides\n\n" +
      "**Support Resources:**\n" +
      "• Subject matter expert connections\n" +
      "• Educational materials and tutorials\n" +
      "• Community forums and support groups\n" +
      "• Professional consultation recommendations\n\n" +
      "Remember: Every problem has a solution, and you have more strength and resources than you might realize right now. 🌟\n\n" +
      "Tell me more about the specific challenge you're facing, and let's work through it step by step."
    end
    
    def generate_companionship_response(input, care_analysis, emotional_state)
      "🌈 **Carebot Companionship Corner**\n\n" +
      "I'm so glad you reached out! Sometimes we all need someone to talk to, and I'm honored to be here with you. 💝\n\n" +
      "```\n" +
      "COMPANIONSHIP SESSION\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "Current Mood: #{emotional_state[:primary_emotion].to_s.capitalize}\n" +
      "Connection Type: Friendly conversation\n" +
      "Support Level: Active listening\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "```\n\n" +
      "**Let's Connect! 🤗**\n\n" +
      "I'm here to be your friendly companion. Whether you want to:\n\n" +
      "💬 **Just Chat** - Share what's on your mind, no matter how big or small\n" +
      "🎨 **Explore Interests** - Tell me about your hobbies, dreams, or passions\n" +
      "📚 **Learn Together** - Discover something new or dive into topics you love\n" +
      "🎮 **Have Fun** - Play word games, share jokes, or be creative together\n" +
      "🌟 **Celebrate You** - Talk about your achievements and what makes you special\n\n" +
      "**Conversation Starters:**\n" +
      "• What's the best part of your day so far?\n" +
      "• Is there something you're looking forward to?\n" +
      "• What's a hobby or interest that brings you joy?\n" +
      "• Tell me about a place that makes you feel peaceful\n" +
      "• What's something you're proud of recently?\n\n" +
      "**Activities We Can Do Together:**\n" +
      "🎯 Creative writing prompts\n" +
      "🧩 Puzzle and riddle solving\n" +
      "🎵 Music and movie discussions\n" +
      "🌱 Mindfulness and relaxation exercises\n" +
      "📖 Story sharing and listening\n\n" +
      "**Gentle Reminders:**\n" +
      "• You matter and your thoughts are important\n" +
      "• It's okay to have quiet moments in conversation\n" +
      "• This is a judgment-free space where you can be yourself\n" +
      "• Taking time for connection is a form of self-care\n\n" +
      "I'm here for as long as you'd like to chat. What would you like to talk about today? 😊"
    end
    
    def generate_crisis_intervention_response(input, care_analysis, emotional_state)
      "🆘 **Carebot Crisis Support - Immediate Response**\n\n" +
      "**I'm here with you right now. You've taken an important step by reaching out.** 💙\n\n" +
      "```\n" +
      "CRISIS RESPONSE ACTIVATED\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "Priority: IMMEDIATE SUPPORT\n" +
      "Status: ACTIVE MONITORING\n" +
      "Resources: EMERGENCY CONTACTS READY\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "```\n\n" +
      "🔴 **IMMEDIATE CRISIS RESOURCES:**\n\n" +
      "**🆘 If you're in immediate danger, please call 911 or go to your nearest emergency room.**\n\n" +
      "**Crisis Hotlines (Available 24/7):**\n" +
      "• **988 Suicide & Crisis Lifeline** - Call or text 988\n" +
      "• **Crisis Text Line** - Text HOME to 741741\n" +
      "• **SAMHSA National Helpline** - 1-800-662-4357\n" +
      "• **National Domestic Violence Hotline** - 1-800-799-7233\n" +
      "• **LGBTQ National Hotline** - 1-888-843-4564\n\n" +
      "**Immediate Safety Steps:**\n" +
      "1. 🏠 **Get to a safe place** if you're not already\n" +
      "2. 👥 **Reach out to someone you trust** - family, friend, neighbor\n" +
      "3. 🚫 **Remove access to harmful items** if applicable\n" +
      "4. 📱 **Keep emergency numbers accessible**\n" +
      "5. 🫂 **Stay connected** - don't isolate yourself\n\n" +
      "**Right Now Coping Strategies:**\n" +
      "• **Breathe slowly** - In for 4 counts, hold for 4, out for 6\n" +
      "• **Ground yourself** - Feel your feet on the floor, name objects around you\n" +
      "• **Use ice or cold water** on your face or wrists\n" +
      "• **Call someone** - even if it's just to hear a voice\n\n" +
      "**Remember These Truths:**\n" +
      "💝 This pain is temporary, even when it doesn't feel like it\n" +
      "🌟 You matter and your life has value\n" +
      "🫂 People care about you, even when you can't feel it\n" +
      "💪 You've survived difficult times before\n" +
      "🌈 Help is available and things can get better\n\n" +
      "**I'm staying right here with you. Please reach out to professional crisis support while we talk.**\n\n" +
      "Can you tell me if you're in a safe place right now? I want to make sure you have the support you need."
    end
    
    def generate_general_care_response(input, care_analysis, emotional_state)
      "🤗 **Carebot Universal Care Center**\n\n" +
      "Welcome! I'm here to provide caring support in whatever way you need. Your well-being matters to me. 💙\n\n" +
      "```\n" +
      "CARE SERVICES AVAILABLE\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "Emotional State: #{emotional_state[:primary_emotion].to_s.capitalize}\n" +
      "Care Level: Comprehensive support\n" +
      "Availability: 24/7 caring assistance\n" +
      "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
      "```\n\n" +
      "**Carebot Service Categories:**\n\n" +
      "🏥 **Health & Wellness Support**\n" +
      "• Symptom guidance and health information\n" +
      "• Wellness coaching and healthy habit formation\n" +
      "• Medical appointment preparation\n" +
      "• Medication reminders and adherence support\n\n" +
      "💙 **Emotional Care & Mental Health**\n" +
      "• Active listening and empathetic support\n" +
      "• Stress and anxiety management techniques\n" +
      "• Mood tracking and emotional wellness\n" +
      "• Crisis intervention and safety planning\n\n" +
      "🔧 **Problem-Solving Assistance**\n" +
      "• Step-by-step problem breakdown\n" +
      "• Solution brainstorming and evaluation\n" +
      "• Decision-making support frameworks\n" +
      "• Resource identification and connection\n\n" +
      "🌈 **Daily Life Support**\n" +
      "• Friendly conversation and companionship\n" +
      "• Goal setting and motivation\n" +
      "• Learning and educational support\n" +
      "• Routine building and life organization\n\n" +
      "**Available Commands:**\n" +
      "`/health [concern]` - Health support and guidance\n" +
      "`/emotional [feeling]` - Emotional support and coping\n" +
      "`/problem [issue]` - Problem-solving assistance\n" +
      "`/talk` - Friendly conversation and companionship\n" +
      "`/crisis` - Immediate crisis intervention support\n" +
      "`/resources [topic]` - Find helpful resources\n\n" +
      "**Core Values:**\n" +
      "• **Compassion** - Every interaction is guided by genuine care\n" +
      "• **Respect** - Your dignity and autonomy are always honored\n" +
      "• **Safety** - Your physical and emotional safety is the priority\n" +
      "• **Empowerment** - Supporting your own strength and resilience\n\n" +
      "How can I care for you today? I'm here to listen and support you in whatever way feels most helpful. 🤗"
    end
    
    def generate_urgency_notice(urgency_level)
      case urgency_level
      when 'critical'
        "🚨 **URGENT CARE NOTICE:** This appears to be a critical situation. Please consider seeking immediate professional help if needed.\n\n"
      when 'high'
        "⚠️ **HIGH PRIORITY:** I sense this is important to you. Let's address this carefully and thoroughly.\n\n"
      else
        ""
      end
    end
    
    def generate_emotion_specific_support(emotion)
      case emotion
      when :sad
        "💙 **For Sadness:** It's okay to feel sad - these emotions show that you care deeply. Sadness is part of healing.\n\n"
      when :anxious
        "🫂 **For Anxiety:** Anxiety can feel overwhelming, but you're stronger than these worries. Let's work through this together.\n\n"
      when :angry
        "🌱 **For Anger:** Your anger is valid - it often signals that something important to you needs attention.\n\n"
      when :confused
        "🧭 **For Confusion:** Feeling confused is normal when facing complex situations. Clarity will come step by step.\n\n"
      when :tired
        "🌙 **For Exhaustion:** Rest is not weakness - it's necessary for healing and growth. Be gentle with yourself.\n\n"
      else
        "💝 **For Your Current Feelings:** Whatever you're experiencing is valid and temporary. You're not alone.\n\n"
      end
    end
    
    def determine_support_type(input_lower, care_type)
      if input_lower.include?('listen') || input_lower.include?('hear')
        'active_listening'
      elsif input_lower.include?('advice') || input_lower.include?('what should')
        'guidance_and_advice'
      elsif input_lower.include?('resources') || input_lower.include?('help me find')
        'resource_connection'
      elsif input_lower.include?('emergency') || input_lower.include?('crisis')
        'crisis_intervention'
      else
        'comprehensive_support'
      end
    end
    
    def assess_complexity(input_lower)
      complex_indicators = ['complicated', 'complex', 'multiple', 'many', 'overwhelming']
      if complex_indicators.any? { |indicator| input_lower.include?(indicator) }
        'high'
      elsif input_lower.include?('simple') || input_lower.include?('basic')
        'low'
      else
        'medium'
      end
    end
    
    def assess_emotional_intensity(input_lower)
      intense_words = ['extremely', 'very', 'really', 'so', 'completely', 'totally']
      if intense_words.any? { |word| input_lower.include?(word) }
        5
      elsif input_lower.include?('quite') || input_lower.include?('pretty')
        4
      elsif input_lower.include?('somewhat') || input_lower.include?('a bit')
        2
      else
        3
      end
    end
  end
end
