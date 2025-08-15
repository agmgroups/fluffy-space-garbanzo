# frozen_string_literal: true

# EmotiSense Controller - Mood & Emotion Analyzer
# Handles real-time emotion detection, mood tracking, and empathetic AI interactions
class EmotisenseController < ApplicationController
  before_action :set_agent
  before_action :initialize_session
  layout 'emotisense'

  # Main EmotiSense dashboard with mood visualization
  def index
    @current_mood = session[:emotisense_mood] || 'neutral'
    @emotion_history = session[:emotion_history] || []
    @daily_mood_stats = calculate_daily_mood_stats
    @active_visualizations = session[:active_visualizations] || default_visualizations
    
    # Agent stats for the interface
    @agent_stats = {
      total_conversations: @agent.total_conversations,
      average_rating: @agent.average_rating.round(1),
      response_time: '< 2s',
      specializations: @agent.specializations
    }
    
    # Real-time emotion context
    @emotion_context = {
      current_session_length: session_duration,
      total_interactions: session[:interaction_count] || 0,
      dominant_emotions: get_dominant_emotions,
      emotional_journey: build_emotional_journey
    }
  end

  # Process user input and return emotion analysis with empathetic response
  def process_emotion
    input_text = params[:message]
    context = {
      session_id: session.id,
      timestamp: Time.current,
      interaction_count: (session[:interaction_count] || 0) + 1
    }

    # Process through EmotiSense engine
    result = @emotisense_engine.process_input(input_text, context)
    
    # Update session with emotion data
    update_emotion_session(result)
    
    # Prepare response with full emotional intelligence
    response_data = {
      empathetic_response: result[:response],
      emotion_analysis: result[:emotion_analysis],
      ui_triggers: result[:ui_triggers],
      mood_state: result[:mood_state],
      suggestions: result[:suggestions],
      visualizations: result[:visualizations],
      session_context: @emotion_context
    }

    render json: response_data
  end

  # Voice emotion analysis endpoint
  def analyze_voice
    # In a real implementation, this would process audio data
    # audio_data = params[:audio_data] # Future implementation
    
    # Simulated voice emotion analysis
    voice_analysis = {
      tone_analysis: {
        pitch_variation: rand(0.1..1.0),
        speaking_rate: ['slow', 'normal', 'fast'].sample,
        volume_consistency: rand(0.3..1.0),
        emotional_stress: rand(0.0..0.8)
      },
      detected_emotions: {
        primary: ['joy', 'sadness', 'anger', 'fear', 'excitement'].sample,
        secondary: ['calm', 'anxious', 'confident', 'uncertain'].sample,
        confidence: rand(0.6..0.95)
      },
      recommendations: [
        "Your voice shows signs of #{['stress', 'excitement', 'calm', 'tension'].sample}",
        "Consider #{['taking deep breaths', 'speaking slower', 'relaxing shoulders'].sample}",
        "Your emotional state appears #{['stable', 'fluctuating', 'positive', 'complex'].sample}"
      ]
    }

    render json: {
      voice_analysis: voice_analysis,
      ui_updates: generate_voice_ui_updates(voice_analysis)
    }
  end

  # Mood tracking and journaling
  def mood_journal
    if request.post?
      mood_entry = {
        timestamp: Time.current,
        mood_rating: params[:mood_rating].to_i,
        emotions: params[:emotions] || [],
        notes: params[:notes],
        triggers: params[:triggers] || [],
        energy_level: params[:energy_level]
      }
      
      save_mood_entry(mood_entry)
      
      render json: {
        success: true,
        message: "Mood entry saved! 💜 Thank you for sharing your emotional journey.",
        mood_insights: generate_mood_insights(mood_entry)
      }
    else
      @mood_history = get_mood_history
      @mood_patterns = analyze_mood_patterns
      render :mood_journal
    end
  end

  # Emotion visualization dashboard
  def emotion_dashboard
    @real_time_emotions = session[:emotion_history] || []
    @emotion_wheel_data = generate_emotion_wheel_data
    @mood_timeline = generate_mood_timeline_data
    @emotional_insights = generate_emotional_insights
    @biometric_data = simulate_biometric_data
    
    respond_to do |format|
      format.html
      format.json do
        render json: {
          emotion_wheel: @emotion_wheel_data,
          mood_timeline: @mood_timeline,
          insights: @emotional_insights,
          biometrics: @biometric_data
        }
      end
    end
  end

  # Empathy training and emotional learning
  def empathy_training
    @training_scenarios = get_empathy_scenarios
    @user_progress = get_empathy_progress
    @current_scenario = params[:scenario_id] ? find_scenario(params[:scenario_id]) : @training_scenarios.first
  end

  # Process empathy training responses
  def process_empathy_response
    scenario_id = params[:scenario_id]
    user_response = params[:response]
    
    # Analyze empathetic response quality
    empathy_analysis = analyze_empathy_response(user_response, scenario_id)
    
    # Update user progress
    update_empathy_progress(empathy_analysis)
    
    render json: {
      analysis: empathy_analysis,
      feedback: generate_empathy_feedback(empathy_analysis),
      next_scenario: get_next_scenario(scenario_id)
    }
  end

  # Emotion-based meditation and wellness
  def wellness_center
    current_emotion = session[:current_emotion] || 'neutral'
    @personalized_activities = get_wellness_activities(current_emotion)
    @guided_meditations = get_emotion_meditations(current_emotion)
    @breathing_exercises = get_breathing_exercises(current_emotion)
    @mood_boosters = get_mood_boosters(current_emotion)
  end

  # Real-time emotion chat interface
  def emotion_chat
    @chat_history = session[:emotion_chat] || []
    @current_emotional_state = session[:current_emotional_state] || {}
  end

  # Export emotion data for analysis
  def export_data
    emotion_data = {
      user_id: session.id,
      export_date: Time.current,
      emotion_history: session[:emotion_history] || [],
      mood_journal: session[:mood_journal] || [],
      session_data: session[:emotisense_session_data] || {},
      insights: generate_export_insights
    }
    
    respond_to do |format|
      format.json { render json: emotion_data }
      format.csv do
        csv_data = generate_emotion_csv(emotion_data)
        send_data csv_data, filename: "emotisense_data_#{Date.current}.csv"
      end
    end
  end

  private

  def set_agent
    @agent = Agent.find_by(agent_type: :emotisense, status: 'active') || Agent.find_by(agent_type: :emotisense)
    
    unless @agent
      @agent = Agent.create!(
        name: "EmotiSense",
        agent_type: :emotisense,
        status: 'active',
        description: "Advanced Mood & Emotion Analyzer with empathetic AI capabilities",
        personality_traits: ['empathetic', 'intuitive', 'compassionate', 'insightful', 'supportive'],
        capabilities: ['emotion_detection', 'mood_analysis', 'empathy_training', 'wellness_guidance'],
        specializations: ['emotional_intelligence', 'mood_tracking', 'therapeutic_conversation'],
        configuration: {
          'emoji' => '💜',
          'tagline' => 'Your empathetic emotional intelligence companion',
          'primary_color' => '#6c5ce7',
          'secondary_color' => '#a29bfe',
          'accent_color' => '#fd79a8'
        }
      )
    end
    
    @emotisense_engine = Agents::EmotisenseEngine.new(@agent) if @agent
  end

  def initialize_session
    session[:emotisense_session_start] ||= Time.current
    session[:interaction_count] ||= 0
    session[:emotion_history] ||= []
    session[:current_emotional_state] ||= { mood: 'neutral', energy: 'moderate' }
  end

  def session_duration
    ((Time.current - Time.parse(session[:emotisense_session_start].to_s)) / 1.minute).round
  end

  def current_user
    # Placeholder for user authentication
    # In a real app, this would return the logged-in user
    nil
  end

  def update_emotion_session(result)
    session[:interaction_count] += 1
    session[:current_emotion] = result[:emotion_analysis][:primary_emotion]
    session[:emotisense_mood] = result[:mood_state]
    
    # Add to emotion history (keep last 20 entries)
    emotion_entry = {
      timestamp: Time.current,
      emotion: result[:emotion_analysis][:primary_emotion],
      intensity: result[:emotion_analysis][:intensity],
      confidence: result[:emotion_analysis][:confidence],
      ui_triggers: result[:ui_triggers]
    }
    
    session[:emotion_history] ||= []
    session[:emotion_history] << emotion_entry
    session[:emotion_history] = session[:emotion_history].last(20)
    
    # Store active visualizations
    session[:active_visualizations] = result[:visualizations]
  end

  def calculate_daily_mood_stats
    emotions = session[:emotion_history] || []
    today_emotions = emotions.select { |e| Date.parse(e[:timestamp].to_s) == Date.current }
    
    if today_emotions.empty?
      return { dominant_mood: 'neutral', mood_changes: 0, average_intensity: 'moderate' }
    end
    
    emotion_counts = today_emotions.group_by { |e| e[:emotion] }
    dominant_mood = emotion_counts.max_by { |_, emotions| emotions.length }&.first || 'neutral'
    
    intensities = today_emotions.map { |e| intensity_to_number(e[:intensity]) }
    average_intensity = number_to_intensity(intensities.sum.to_f / intensities.length)
    
    {
      dominant_mood: dominant_mood,
      mood_changes: today_emotions.length,
      average_intensity: average_intensity,
      emotion_distribution: emotion_counts.transform_values(&:length)
    }
  end

  def get_dominant_emotions
    emotions = session[:emotion_history] || []
    return {} if emotions.empty?
    
    emotion_counts = emotions.group_by { |e| e[:emotion] }
    emotion_counts.transform_values(&:length)
               .sort_by { |_, count| -count }
               .first(3)
               .to_h
  end

  def build_emotional_journey
    emotions = session[:emotion_history] || []
    emotions.last(10).map do |emotion_data|
      {
        time: time_ago_in_words(Time.parse(emotion_data[:timestamp].to_s)),
        emotion: emotion_data[:emotion].to_s.humanize,
        intensity: emotion_data[:intensity],
        color: get_emotion_color(emotion_data[:emotion])
      }
    end
  end

  def default_visualizations
    {
      emotion_wheel: true,
      mood_timeline: true,
      intensity_bars: true,
      ambient_effects: true,
      particle_system: false
    }
  end

  def generate_voice_ui_updates(voice_analysis)
    {
      background_pulse: voice_analysis[:tone_analysis][:emotional_stress] > 0.5,
      color_shift: determine_voice_color(voice_analysis[:detected_emotions][:primary]),
      animation_speed: voice_analysis[:tone_analysis][:speaking_rate],
      ambient_intensity: voice_analysis[:detected_emotions][:confidence]
    }
  end

  def save_mood_entry(mood_entry)
    session[:mood_journal] ||= []
    session[:mood_journal] << mood_entry
    session[:mood_journal] = session[:mood_journal].last(50) # Keep last 50 entries
  end

  def generate_mood_insights(mood_entry)
    recent_entries = (session[:mood_journal] || []).last(7)
    
    if recent_entries.length < 2
      return ["Thank you for starting your emotional journey with us! 💜"]
    end
    
    # Analyze patterns
    ratings = recent_entries.map { |e| e[:mood_rating] }
    trend = ratings.last - ratings.first
    
    insights = []
    
    if trend > 0
      insights << "Your mood has been trending upward! 📈✨"
    elsif trend < 0
      insights << "I notice some challenges lately. Remember, every emotion is valid. 🤗"
    else
      insights << "Your emotional state has been quite stable. 🧘‍♀️"
    end
    
    # Common emotion analysis
    all_emotions = recent_entries.flat_map { |e| e[:emotions] }.compact
    if all_emotions.any?
      common_emotion = all_emotions.group_by(&:itself).max_by { |_, v| v.length }&.first
      insights << "#{common_emotion.humanize} seems to be a recurring theme for you."
    end
    
    insights
  end

  def get_mood_history
    session[:mood_journal] || []
  end

  def analyze_mood_patterns
    entries = get_mood_history
    return {} if entries.length < 3
    
    {
      weekly_average: calculate_weekly_average(entries),
      most_common_triggers: find_common_triggers(entries),
      energy_patterns: analyze_energy_patterns(entries),
      emotional_vocabulary: analyze_emotional_vocabulary(entries)
    }
  end

  def generate_emotion_wheel_data
    emotions = session[:emotion_history] || []
    return [] if emotions.empty?
    
    recent_emotions = emotions.last(10)
    emotion_counts = recent_emotions.group_by { |e| e[:emotion] }
    total = recent_emotions.length
    
    emotion_counts.map do |emotion, instances|
      {
        emotion: emotion.to_s.humanize,
        percentage: (instances.length.to_f / total * 100).round(1),
        color: get_emotion_color(emotion),
        intensity: calculate_average_intensity(instances)
      }
    end
  end

  def generate_mood_timeline_data
    emotions = session[:emotion_history] || []
    emotions.last(15).map.with_index do |emotion_data, index|
      {
        x: index,
        y: intensity_to_number(emotion_data[:intensity]),
        emotion: emotion_data[:emotion],
        color: get_emotion_color(emotion_data[:emotion]),
        timestamp: emotion_data[:timestamp]
      }
    end
  end

  def generate_emotional_insights
    emotions = session[:emotion_history] || []
    return [] if emotions.empty?
    
    insights = []
    
    # Recent emotion analysis
    recent_emotion = emotions.last[:emotion]
    insights << "You're currently experiencing #{recent_emotion.to_s.humanize.downcase} 💜"
    
    # Emotional diversity
    unique_emotions = emotions.map { |e| e[:emotion] }.uniq
    if unique_emotions.length >= 4
      insights << "You have a rich emotional range! This shows great emotional awareness 🌈"
    end
    
    # Intensity patterns
    high_intensity_count = emotions.count { |e| ['very_high', 'extreme'].include?(e[:intensity]) }
    if high_intensity_count > emotions.length * 0.3
      insights << "You experience emotions quite intensely. Consider grounding techniques 🧘‍♀️"
    end
    
    insights
  end

  def simulate_biometric_data
    # In a real implementation, this would connect to actual biometric devices
    {
      heart_rate: rand(60..100),
      stress_level: rand(0.1..0.8),
      breathing_rate: rand(12..20),
      emotional_coherence: rand(0.3..0.9),
      timestamp: Time.current
    }
  end

  def get_empathy_scenarios
    [
      {
        id: 1,
        title: "Friend Going Through Breakup",
        description: "Your close friend just went through a difficult breakup and is feeling devastated.",
        context: "They've been together for 3 years and didn't see it coming.",
        emotion_focus: "sadness, loss, confusion"
      },
      {
        id: 2,
        title: "Colleague Feeling Overwhelmed",
        description: "A coworker seems stressed and overwhelmed with their workload.",
        context: "They've been working late every day and seem exhausted.",
        emotion_focus: "stress, anxiety, burnout"
      },
      {
        id: 3,
        title: "Family Member Excited About Achievement",
        description: "Your sibling just got accepted to their dream university.",
        context: "They've worked really hard for this and are over the moon.",
        emotion_focus: "joy, excitement, pride"
      }
    ]
  end

  def get_wellness_activities(emotion)
    activities = {
      sadness: [
        { title: "Gentle Self-Care Ritual", duration: "15 min", type: "self-care" },
        { title: "Gratitude Journaling", duration: "10 min", type: "reflection" },
        { title: "Comforting Music Playlist", duration: "30 min", type: "audio" }
      ],
      anger: [
        { title: "Progressive Muscle Relaxation", duration: "20 min", type: "physical" },
        { title: "Anger Release Writing", duration: "15 min", type: "expression" },
        { title: "Cooling Breath Exercise", duration: "5 min", type: "breathing" }
      ],
      joy: [
        { title: "Celebration Dance", duration: "10 min", type: "movement" },
        { title: "Share the Joy", duration: "15 min", type: "social" },
        { title: "Creative Expression", duration: "30 min", type: "creativity" }
      ]
    }
    
    activities[emotion.to_sym] || activities[:sadness] # Default to calming activities
  end

  def intensity_to_number(intensity)
    case intensity
    when 'low' then 1
    when 'moderate' then 2
    when 'high' then 3
    when 'very_high' then 4
    when 'extreme' then 5
    else 2
    end
  end

  def number_to_intensity(number)
    case number.round
    when 1 then 'low'
    when 2 then 'moderate'
    when 3 then 'high'
    when 4 then 'very_high'
    when 5 then 'extreme'
    else 'moderate'
    end
  end

  def get_emotion_color(emotion)
    color_map = {
      joy: '#ffd700',
      sadness: '#74b9ff',
      anger: '#ff7675',
      fear: '#636e72',
      excitement: '#fdcb6e',
      love: '#fd79a8',
      calm: '#00b894'
    }
    
    color_map[emotion.to_sym] || '#6c5ce7' # Default purple
  end

  def calculate_average_intensity(emotion_instances)
    return 'moderate' if emotion_instances.empty?
    
    intensities = emotion_instances.map { |e| intensity_to_number(e[:intensity]) }
    average = intensities.sum.to_f / intensities.length
    number_to_intensity(average)
  end

  def get_emotion_meditations(emotion)
    meditations = {
      sadness: [
        { title: "Healing Heart Meditation", duration: "15 min", guide: "Dr. Sarah Chen" },
        { title: "Self-Compassion Practice", duration: "20 min", guide: "Marcus Williams" },
        { title: "Gentle Release Meditation", duration: "12 min", guide: "Luna Park" }
      ],
      anger: [
        { title: "Cooling Fire Meditation", duration: "18 min", guide: "Dr. Maria Santos" },
        { title: "Inner Peace Practice", duration: "25 min", guide: "James Morrison" },
        { title: "Emotional Balance", duration: "15 min", guide: "Zen Master Kim" }
      ],
      joy: [
        { title: "Gratitude Expansion", duration: "10 min", guide: "Happy Singh" },
        { title: "Joy Sharing Meditation", duration: "20 min", guide: "Dr. Light" },
        { title: "Celebration Practice", duration: "15 min", guide: "Joy Masters" }
      ]
    }
    
    meditations[emotion.to_sym] || meditations[:sadness]
  end

  def get_breathing_exercises(emotion)
    exercises = {
      sadness: [
        { name: "4-7-8 Calming Breath", technique: "Inhale 4, Hold 7, Exhale 8", duration: "5 min" },
        { name: "Heart Coherence", technique: "5 sec in, 5 sec out", duration: "10 min" },
        { name: "Gentle Wave Breathing", technique: "Natural rhythm", duration: "8 min" }
      ],
      anger: [
        { name: "Cooling Breath", technique: "Tongue curl inhale", duration: "6 min" },
        { name: "Square Breathing", technique: "4-4-4-4 pattern", duration: "10 min" },
        { name: "Release Breath", technique: "Quick inhale, long exhale", duration: "7 min" }
      ],
      joy: [
        { name: "Energizing Breath", technique: "Quick shallow breaths", duration: "3 min" },
        { name: "Celebration Breath", technique: "Deep belly breaths", duration: "5 min" },
        { name: "Joy Breathing", technique: "Smile while breathing", duration: "10 min" }
      ]
    }
    
    exercises[emotion.to_sym] || exercises[:sadness]
  end

  def get_mood_boosters(emotion)
    boosters = {
      sadness: [
        { activity: "Watch funny animal videos", time: "15 min", effect: "Endorphin boost" },
        { activity: "Call a supportive friend", time: "20 min", effect: "Social connection" },
        { activity: "Create something beautiful", time: "30 min", effect: "Accomplishment" }
      ],
      anger: [
        { activity: "Physical exercise", time: "20 min", effect: "Energy release" },
        { activity: "Listen to calming music", time: "15 min", effect: "Nervous system reset" },
        { activity: "Practice forgiveness", time: "10 min", effect: "Emotional freedom" }
      ],
      joy: [
        { activity: "Share your happiness", time: "10 min", effect: "Amplified joy" },
        { activity: "Dance to favorite music", time: "15 min", effect: "Physical expression" },
        { activity: "Plan something fun", time: "20 min", effect: "Future anticipation" }
      ]
    }
    
    boosters[emotion.to_sym] || boosters[:sadness]
  end

  def calculate_weekly_average(entries)
    return 0 if entries.empty?
    
    weekly_entries = entries.select do |entry|
      Date.parse(entry[:timestamp].to_s) >= 1.week.ago.to_date
    end
    
    return 0 if weekly_entries.empty?
    
    total_rating = weekly_entries.sum { |entry| entry[:mood_rating] || 0 }
    (total_rating.to_f / weekly_entries.length).round(1)
  end

  def find_common_triggers(entries)
    all_triggers = entries.flat_map { |entry| entry[:triggers] || [] }
    return [] if all_triggers.empty?
    
    all_triggers.group_by(&:itself)
               .sort_by { |_, occurrences| -occurrences.length }
               .first(3)
               .map(&:first)
  end

  def analyze_energy_patterns(entries)
    energy_levels = entries.map { |entry| entry[:energy_level] }.compact
    return {} if energy_levels.empty?
    
    energy_counts = energy_levels.group_by(&:itself)
    most_common = energy_counts.max_by { |_, count| count.length }&.first
    
    {
      most_common_energy: most_common,
      energy_distribution: energy_counts.transform_values(&:length)
    }
  end

  def analyze_emotional_vocabulary(entries)
    all_emotions = entries.flat_map { |entry| entry[:emotions] || [] }
    return {} if all_emotions.empty?
    
    {
      unique_emotions: all_emotions.uniq.length,
      most_frequent: all_emotions.group_by(&:itself).max_by { |_, count| count.length }&.first,
      emotional_range: all_emotions.uniq
    }
  end

  def get_empathy_progress
    session[:empathy_progress] ||= {
      scenarios_completed: 0,
      average_empathy_score: 0,
      strengths: [],
      areas_for_growth: []
    }
  end

  def find_scenario(scenario_id)
    get_empathy_scenarios.find { |s| s[:id] == scenario_id.to_i }
  end

  def analyze_empathy_response(response, scenario_id)
    # Simulated empathy analysis
    {
      empathy_score: rand(6..10),
      emotional_recognition: rand(7..10),
      response_appropriateness: rand(6..9),
      active_listening_indicators: rand(5..10),
      suggestions: [
        "Great use of emotional validation!",
        "Consider asking more open-ended questions",
        "Your response showed genuine care"
      ].sample(2)
    }
  end

  def update_empathy_progress(analysis)
    progress = get_empathy_progress
    progress[:scenarios_completed] += 1
    
    # Update average score
    current_average = progress[:average_empathy_score]
    new_score = analysis[:empathy_score]
    progress[:average_empathy_score] = ((current_average * (progress[:scenarios_completed] - 1)) + new_score) / progress[:scenarios_completed]
    
    session[:empathy_progress] = progress
  end

  def generate_empathy_feedback(analysis)
    score = analysis[:empathy_score]
    
    if score >= 9
      "Excellent empathetic response! 🌟 You demonstrated deep understanding and compassion."
    elsif score >= 7
      "Good empathetic response! 💜 You showed care and understanding."
    elsif score >= 5
      "Nice try! 🤗 Consider focusing more on emotional validation."
    else
      "Keep practicing! 💪 Empathy grows with conscious effort."
    end
  end

  def get_next_scenario(current_scenario_id)
    scenarios = get_empathy_scenarios
    current_index = scenarios.index { |s| s[:id] == current_scenario_id.to_i }
    
    if current_index && current_index < scenarios.length - 1
      scenarios[current_index + 1]
    else
      scenarios.first # Loop back to first scenario
    end
  end

  def generate_export_insights
    emotions = session[:emotion_history] || []
    mood_entries = session[:mood_journal] || []
    
    {
      total_interactions: emotions.length,
      emotional_range: emotions.map { |e| e[:emotion] }.uniq.length,
      average_mood_rating: mood_entries.empty? ? 0 : mood_entries.sum { |e| e[:mood_rating] || 0 } / mood_entries.length.to_f,
      most_common_emotion: emotions.group_by { |e| e[:emotion] }.max_by { |_, v| v.length }&.first,
      session_duration_minutes: session_duration
    }
  end

  def generate_emotion_csv(emotion_data)
    require 'csv'
    
    CSV.generate do |csv|
      csv << ['Timestamp', 'Emotion', 'Intensity', 'Confidence', 'Mood Rating', 'Notes']
      
      emotion_data[:emotion_history].each do |emotion|
        csv << [
          emotion[:timestamp],
          emotion[:emotion],
          emotion[:intensity],
          emotion[:confidence],
          '',
          ''
        ]
      end
      
      emotion_data[:mood_journal].each do |entry|
        csv << [
          entry[:timestamp],
          entry[:emotions]&.join(', '),
          '',
          '',
          entry[:mood_rating],
          entry[:notes]
        ]
      end
    end
  end

  def determine_voice_color(emotion)
    get_emotion_color(emotion)
  end

  def time_ago_in_words(time)
    distance = Time.current - time
    
    case distance
    when 0..1.minute
      "just now"
    when 1.minute..1.hour
      "#{(distance / 1.minute).to_i}m ago"
    when 1.hour..1.day
      "#{(distance / 1.hour).to_i}h ago"
    else
      "#{(distance / 1.day).to_i}d ago"
    end
  end
end
