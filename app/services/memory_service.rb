# frozen_string_literal: true

# Memory Service - Handles agent memory operations across the platform
# This service manages how agents store, retrieve, and utilize memories
# to create contextual and personalized experiences

class MemoryService
  MEMORY_IMPORTANCE_THRESHOLD = 5
  MEMORY_DECAY_RATE = 0.1
  MAX_MEMORIES_PER_SESSION = 50
  
  class << self
    def store_memory(agent, user, memory_data)
      return unless valid_memory_data?(memory_data)
      
      memory = AgentMemory.create!(
        agent: agent,
        user: user,
        memory_type: memory_data[:type],
        content: sanitize_memory_content(memory_data[:content]),
        emotional_context: memory_data[:emotional_context],
        importance_score: calculate_importance(memory_data),
        tags: extract_memory_tags(memory_data[:content])
      )
      
      # Clean up old memories if needed
      cleanup_old_memories(agent, user)
      
      memory
    end
    
    def retrieve_memories(agent, user, context = {})
      base_query = agent.agent_memories.where(user: user)
      
      # Apply filters based on context
      filtered_memories = apply_memory_filters(base_query, context)
      
      # Sort by relevance and recency
      sorted_memories = sort_memories_by_relevance(filtered_memories, context)
      
      # Limit results and apply decay
      final_memories = apply_memory_decay(sorted_memories.limit(MAX_MEMORIES_PER_SESSION))
      
      final_memories.to_a
    end
    
    def get_emotional_context(agent, user, emotion_type = nil)
      memories = agent.agent_memories
                      .where(user: user)
                      .where(memory_type: ['emotion', 'conversation'])
      
      memories = memories.where(emotional_context: emotion_type) if emotion_type
      
      # Calculate emotional patterns
      emotional_summary = {
        dominant_emotions: calculate_dominant_emotions(memories),
        emotional_trends: analyze_emotional_trends(memories),
        trigger_patterns: identify_trigger_patterns(memories),
        coping_strategies: extract_successful_strategies(memories)
      }
      
      emotional_summary
    end
    
    def update_memory_importance(memory, interaction_feedback)
      return unless memory && interaction_feedback
      
      # Increase importance based on positive feedback
      importance_boost = case interaction_feedback[:rating]
                        when 4..5 then 2
                        when 3 then 1
                        when 1..2 then -1
                        else 0
                        end
      
      new_importance = [memory.importance_score + importance_boost, 10].min
      memory.update!(importance_score: new_importance)
      
      memory
    end
    
    def forget_memory(memory_id, reason = 'user_request')
      memory = AgentMemory.find_by(id: memory_id)
      return false unless memory
      
      # Soft delete with reason
      memory.update!(
        content: { 'forgotten' => true, 'reason' => reason, 'forgotten_at' => Time.current },
        importance_score: 0
      )
      
      true
    end
    
    def get_memory_summary(agent, user, timeframe = 30.days)
      memories = agent.agent_memories
                      .where(user: user)
                      .where('created_at > ?', timeframe.ago)
      
      {
        total_memories: memories.count,
        memory_types: memories.group(:memory_type).count,
        emotional_distribution: memories.group(:emotional_context).count,
        average_importance: memories.average(:importance_score)&.round(2),
        most_important: memories.order(importance_score: :desc).limit(3),
        recent_activity: memories.order(created_at: :desc).limit(5)
      }
    end
    
    def create_memory_cluster(agent, user, theme)
      # Group related memories by theme/topic
      relevant_memories = find_memories_by_theme(agent, user, theme)
      
      return nil if relevant_memories.empty?
      
      cluster = {
        theme: theme,
        memories: relevant_memories,
        insights: extract_cluster_insights(relevant_memories),
        patterns: identify_cluster_patterns(relevant_memories),
        recommendations: generate_cluster_recommendations(relevant_memories)
      }
      
      cluster
    end
    
    private
    
    def valid_memory_data?(memory_data)
      return false unless memory_data.is_a?(Hash)
      return false unless memory_data[:type].in?(AgentMemory::MEMORY_TYPES)
      return false unless memory_data[:content].present?
      
      true
    end
    
    def sanitize_memory_content(content)
      return content if content.is_a?(Hash)
      
      # Sanitize string content
      {
        'text' => content.to_s.strip,
        'context' => 'user_interaction',
        'stored_at' => Time.current.iso8601
      }
    end
    
    def calculate_importance(memory_data)
      base_importance = 5
      
      # Increase importance for emotional memories
      base_importance += 2 if memory_data[:emotional_context] != 'neutral'
      
      # Increase importance for preference memories
      base_importance += 1 if memory_data[:type] == 'preference'
      
      # Increase importance for achievement memories
      base_importance += 3 if memory_data[:type] == 'achievement'
      
      # Ensure within bounds
      [base_importance, 10].min
    end
    
    def extract_memory_tags(content)
      return [] unless content.is_a?(String)
      
      # Simple tag extraction from content
      words = content.downcase.split(/\W+/)
      meaningful_words = words.select { |word| word.length > 3 }
      
      meaningful_words.first(5)
    end
    
    def apply_memory_filters(base_query, context)
      filtered = base_query
      
      # Filter by memory type if specified
      if context[:memory_types].present?
        filtered = filtered.where(memory_type: context[:memory_types])
      end
      
      # Filter by emotional context if specified
      if context[:emotional_context].present?
        filtered = filtered.where(emotional_context: context[:emotional_context])
      end
      
      # Filter by importance threshold
      importance_threshold = context[:min_importance] || MEMORY_IMPORTANCE_THRESHOLD
      filtered = filtered.where('importance_score >= ?', importance_threshold)
      
      # Filter by recency if specified
      if context[:days_back].present?
        filtered = filtered.where('created_at > ?', context[:days_back].days.ago)
      end
      
      filtered
    end
    
    def sort_memories_by_relevance(memories, context)
      # Default sort by importance and recency
      sorted = memories.order(importance_score: :desc, created_at: :desc)
      
      # If specific context provided, adjust relevance
      if context[:current_emotion].present?
        # Prioritize memories with matching emotional context
        sorted = memories.order(
          Arel.sql("CASE WHEN emotional_context = '#{context[:current_emotion]}' THEN 0 ELSE 1 END"),
          :importance_score => :desc,
          :created_at => :desc
        )
      end
      
      sorted
    end
    
    def apply_memory_decay(memories)
      # Apply decay based on age and importance
      memories.map do |memory|
        days_old = (Time.current - memory.created_at) / 1.day
        decay_factor = 1 - (days_old * MEMORY_DECAY_RATE / 100)
        
        # Memories below threshold lose relevance
        if memory.importance_score * decay_factor < MEMORY_IMPORTANCE_THRESHOLD
          next if decay_factor < 0.5 # Skip very old, unimportant memories
        end
        
        memory
      end.compact
    end
    
    def cleanup_old_memories(agent, user)
      # Remove memories that have decayed beyond usefulness
      old_memories = agent.agent_memories
                          .where(user: user)
                          .where('created_at < ?', 90.days.ago)
                          .where('importance_score < ?', 3)
      
      old_memories.update_all(
        content: { 'archived' => true, 'archived_at' => Time.current },
        importance_score: 0
      )
    end
    
    def calculate_dominant_emotions(memories)
      emotion_counts = memories.group(:emotional_context).count
      total_memories = emotion_counts.values.sum
      
      return {} if total_memories == 0
      
      emotion_counts.transform_values { |count| (count.to_f / total_memories * 100).round(1) }
                   .sort_by { |_emotion, percentage| -percentage }
                   .first(3)
                   .to_h
    end
    
    def analyze_emotional_trends(memories)
      # Analyze emotional patterns over time
      recent_emotions = memories.where('created_at > ?', 7.days.ago)
                               .order(:created_at)
                               .pluck(:emotional_context, :created_at)
      
      return {} if recent_emotions.empty?
      
      # Group by day and find trends
      daily_emotions = recent_emotions.group_by { |_, date| date.to_date }
      
      trend_analysis = daily_emotions.transform_values do |day_emotions|
        day_emotions.map(&:first).tally
      end
      
      trend_analysis
    end
    
    def identify_trigger_patterns(memories)
      # Find patterns in what triggers certain emotions
      emotional_memories = memories.where.not(emotional_context: 'neutral')
      
      patterns = {}
      
      emotional_memories.each do |memory|
        emotion = memory.emotional_context
        content_words = extract_memory_tags(memory.content.to_s)
        
        patterns[emotion] ||= Hash.new(0)
        content_words.each { |word| patterns[emotion][word] += 1 }
      end
      
      # Return most common triggers for each emotion
      patterns.transform_values do |triggers|
        triggers.sort_by { |_word, count| -count }.first(3).to_h
      end
    end
    
    def extract_successful_strategies(memories)
      # Find strategies that led to positive outcomes
      positive_memories = memories.where(emotional_context: ['happy', 'calm', 'confident'])
                                 .where('importance_score > ?', 7)
      
      strategies = positive_memories.map do |memory|
        memory.content['strategy'] || memory.content['context']
      end.compact.uniq
      
      strategies.first(5)
    end
    
    def find_memories_by_theme(agent, user, theme)
      # Search memories by theme/topic
      agent.agent_memories
           .where(user: user)
           .where("content::text ILIKE ? OR tags @> ?", "%#{theme}%", [theme].to_json)
           .order(importance_score: :desc)
           .limit(10)
    end
    
    def extract_cluster_insights(memories)
      # Extract insights from grouped memories
      insights = []
      
      # Emotional patterns
      emotions = memories.map(&:emotional_context).tally
      if emotions.any?
        dominant_emotion = emotions.max_by { |_emotion, count| count }.first
        insights << "This theme is often associated with #{dominant_emotion} feelings"
      end
      
      # Frequency patterns
      if memories.length > 3
        insights << "This is a recurring theme in your conversations"
      end
      
      # Importance patterns
      avg_importance = memories.sum(&:importance_score) / memories.length.to_f
      if avg_importance > 7
        insights << "This theme holds significant importance for you"
      end
      
      insights
    end
    
    def identify_cluster_patterns(memories)
      # Identify patterns within memory clusters
      {
        temporal_pattern: analyze_temporal_pattern(memories),
        emotional_pattern: analyze_emotional_cluster_pattern(memories),
        content_pattern: analyze_content_patterns(memories)
      }
    end
    
    def generate_cluster_recommendations(memories)
      # Generate recommendations based on memory cluster
      recommendations = []
      
      # Based on emotional patterns
      emotions = memories.map(&:emotional_context).uniq
      if emotions.include?('anxious') || emotions.include?('stressed')
        recommendations << "Consider exploring stress management techniques"
      end
      
      if emotions.include?('happy') || emotions.include?('excited')
        recommendations << "This theme seems to bring you joy - explore it further"
      end
      
      # Based on frequency
      if memories.length > 5
        recommendations << "This is clearly important to you - consider deeper exploration"
      end
      
      recommendations
    end
    
    def analyze_temporal_pattern(memories)
      # Analyze when these memories typically occur
      times_of_day = memories.map { |m| m.created_at.hour }.tally
      dominant_time = times_of_day.max_by { |_hour, count| count }&.first
      
      if dominant_time
        time_description = case dominant_time
                          when 6..11 then "morning"
                          when 12..17 then "afternoon"
                          when 18..21 then "evening"
                          else "night"
                          end
        "Most active during #{time_description} hours"
      else
        "No clear temporal pattern"
      end
    end
    
    def analyze_emotional_cluster_pattern(memories)
      emotions = memories.map(&:emotional_context)
      emotion_sequence = emotions.each_cons(2).tally
      
      if emotion_sequence.any?
        "Common emotional transitions: #{emotion_sequence.keys.first(2).map { |pair| pair.join(' → ') }.join(', ')}"
      else
        "Single emotional context"
      end
    end
    
    def analyze_content_patterns(memories)
      all_tags = memories.flat_map(&:tags).tally
      common_tags = all_tags.sort_by { |_tag, count| -count }.first(3).map(&:first)
      
      "Common themes: #{common_tags.join(', ')}"
    end
  end
end
