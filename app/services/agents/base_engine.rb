# frozen_string_literal: true

module Agents
  # Base Agent Engine - The foundation for all AI agents in our multiverse
  # This provides the core framework that every agent inherits from
  
  class BaseEngine
    attr_reader :agent, :memory_service, :personality
    
    def initialize(agent)
      @agent = agent
      @memory_service = initialize_memory_service(agent)
      @personality = initialize_personality_engine(agent)
    end
    
    # Main processing method - Override in specific agent engines
    def process_input(user, input, context = {})
      start_time = Time.current
      
      # Load user context and memories
      user_context = load_user_context(user, context)
      
      # Analyze input
      input_analysis = analyze_input(input, user_context)
      
      # Generate response based on agent type
      response = generate_response(input_analysis, user_context)
      
      # Apply personality filter
      final_response = personality.apply_personality_filter(response)
      
      # Store memory
      store_interaction_memory(user, input, final_response, input_analysis)
      
      processing_time = Time.current - start_time
      
      {
        text: final_response,
        emotion: input_analysis[:emotion],
        confidence: input_analysis[:confidence],
        processing_time: processing_time,
        agent_mood: personality.current_mood,
        suggestions: generate_suggestions(input_analysis, user_context)
      }
    rescue StandardError => e
      Rails.logger.error "Agent processing error: #{e.message}"
      {
        text: get_error_response,
        emotion: 'neutral',
        confidence: 0.5,
        processing_time: 0.1,
        error: true
      }
    end
    
    # Core methods to be overridden by specific agents
    def generate_response(input_analysis, user_context)
      "I'm #{agent.display_name}. #{agent.tagline}"
    end
    
    def analyze_input(input, context)
      {
        text: input,
        emotion: EmotionAnalyzer.detect_emotion(input),
        intent: IntentClassifier.classify(input),
        entities: EntityExtractor.extract(input),
        confidence: 0.8,
        keywords: extract_keywords(input)
      }
    end
    
    def can_handle?(input_type)
      agent.capabilities.include?(input_type.to_s)
    end
    
    protected
    
    # Load user context including memories and preferences
    def load_user_context(user, additional_context = {})
      memories = memory_service.recall_memories(user, 10)
      preferences = extract_user_preferences(memories)
      
      {
        user: user,
        memories: memories,
        preferences: preferences,
        conversation_history: get_recent_conversations(user),
        emotional_state: detect_user_emotional_state(memories),
        time_context: Time.current,
        additional: additional_context
      }
    end
    
    # Store interaction in agent memory
    def store_interaction_memory(user, input, response, analysis)
      memory_data = {
        type: 'conversation',
        content: {
          input: input,
          response: response,
          emotion: analysis[:emotion],
          intent: analysis[:intent],
          context: analysis[:keywords]
        },
        emotion: analysis[:emotion],
        importance: calculate_memory_importance(analysis)
      }
      
      memory_service.store_memory(user, memory_data)
    end
    
    # Generate conversation suggestions
    def generate_suggestions(input_analysis, user_context)
      base_suggestions = [
        "Tell me more about that",
        "How are you feeling about this?",
        "What would you like to explore next?"
      ]
      
      # Add agent-specific suggestions
      agent_suggestions = get_agent_specific_suggestions(input_analysis, user_context)
      
      (base_suggestions + agent_suggestions).first(3)
    end
    
    # Agent-specific suggestion method (override in subclasses)
    def get_agent_specific_suggestions(input_analysis, user_context)
      []
    end
    
    # Error handling
    def get_error_response
      error_responses = [
        "I'm having trouble processing that right now. Could you try rephrasing?",
        "Something went wrong on my end. Let me try again.",
        "I need a moment to gather my thoughts. Can you give me a different input?"
      ]
      
      personality.apply_personality_filter(error_responses.sample)
    end
    
    private
    
    def initialize_memory_service(agent)
      # Placeholder for memory service - can be enhanced later
      OpenStruct.new(
        recall_memories: ->(user, limit) { [] },
        store_memory: ->(user, data) { true }
      )
    end
    
    def initialize_personality_engine(agent)
      # Placeholder for personality engine - can be enhanced later
      OpenStruct.new(
        current_mood: 'neutral',
        apply_personality_filter: ->(text) { text }
      )
    end
    
    def extract_keywords(text)
      # Simple keyword extraction - can be enhanced with NLP libraries
      text.downcase
          .gsub(/[^\w\s]/, '')
          .split
          .reject { |word| word.length < 3 }
          .uniq
    end
    
    def extract_user_preferences(memories)
      memories
        .select { |m| m.memory_type == 'preference' }
        .map { |m| [m.content['key'], m.content['value']] }
        .to_h
    end
    
    def get_recent_conversations(user)
      agent.agent_interactions
           .where(user: user)
           .recent
           .limit(5)
           .pluck(:input, :response)
    end
    
    def detect_user_emotional_state(memories)
      recent_emotions = memories
                       .select { |m| m.memory_type == 'emotion' }
                       .first(3)
                       .map(&:emotional_context)
      
      return 'neutral' if recent_emotions.empty?
      
      # Find most common recent emotion
      recent_emotions
        .group_by(&:itself)
        .max_by { |_, emotions| emotions.length }
        &.first || 'neutral'
    end
    
    def calculate_memory_importance(analysis)
      base_importance = 3
      
      # Boost importance for strong emotions
      base_importance += 2 if %w[excited anxious inspired frustrated].include?(analysis[:emotion])
      
      # Boost for high confidence
      base_importance += 1 if analysis[:confidence] > 0.8
      
      # Boost for specific intents
      base_importance += 1 if %w[goal_setting personal_sharing].include?(analysis[:intent])
      
      [base_importance, 10].min
    end
  end
end
