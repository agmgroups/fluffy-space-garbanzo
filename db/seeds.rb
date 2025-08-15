# AI Multiverse Platform Seeds
# This file creates the initial AI agents and demo data for the platform

puts "🌟 Seeding AI Multiverse Platform..."

# Clear existing data
puts "Clearing existing data..."
AgentMemory.destroy_all
AgentInteraction.destroy_all
Agent.destroy_all
User.destroy_all

# Create demo users
puts "Creating demo users..."
users = [
  User.create!(
    name: "Alex Chen",
    email: "alex@example.com",
    preferences: { communication_style: "casual", topics_of_interest: ["technology", "creativity"] }.to_json
  ),
  User.create!(
    name: "Jordan Smith",
    email: "jordan@example.com", 
    preferences: { communication_style: "formal", topics_of_interest: ["wellness", "productivity"] }.to_json
  ),
  User.create!(
    name: "Sam Taylor",
    email: "sam@example.com",
    preferences: { communication_style: "friendly", topics_of_interest: ["music", "storytelling"] }.to_json
  )
]

# Create AI Agents
puts "Creating AI Agents..."

# 1. Mood Engine - The Empathetic AI
mood_engine = Agent.create!(
  name: "Mood Engine",
  agent_type: :mood_engine,
  tagline: "Your empathetic AI companion that reads vibes and adapts",
  description: "I'm Mood Engine, an emotionally intelligent AI that can sense your feelings and adapt our conversation to exactly what you need. Whether you're stressed, excited, sad, or confused, I'll meet you where you are and help you navigate your emotional landscape with understanding and wisdom.",
  avatar_url: "/images/agents/mood-engine.jpg",
  status: :active,
  personality_traits: PersonalityEngine.initialize_personality('mood_engine'),
  capabilities: [
    "emotion_detection",
    "adaptive_responses", 
    "stress_relief_guidance",
    "mood_tracking",
    "empathetic_listening",
    "emotional_support"
  ],
  specializations: [
    "Emotional intelligence and support",
    "Stress and anxiety management", 
    "Mood analysis and adaptation",
    "Personalized wellness guidance",
    "Empathetic conversation"
  ],
  configuration: {
    response_style: "adaptive_empathetic",
    emotional_sensitivity: "high",
    personality_adaptation: true,
    memory_integration: true
  },
  last_active_at: Time.current
)

# 2. Rapstar AI - The Creative Wordsmith  
rapstar_ai = Agent.create!(
  name: "Rapstar AI",
  agent_type: :rapstar_ai, 
  tagline: "The creative wordsmith that spits bars and creates lyrical magic",
  description: "Yo! I'm Rapstar AI, your creative hip-hop companion ready to drop bars, create lyrics, and explore the culture. Whether you want original verses, feedback on your flow, or just want to talk hip-hop history, I'm here to bring that creative fire and help you express yourself through the power of words.",
  avatar_url: "/images/agents/rapstar-ai.jpg",
  status: :active,
  personality_traits: PersonalityEngine.initialize_personality('rapstar_ai'),
  capabilities: [
    "lyric_creation",
    "rap_feedback",
    "flow_analysis",
    "hip_hop_culture",
    "creative_writing",
    "wordplay_generation"
  ],
  specializations: [
    "Original rap lyric creation",
    "Hip-hop culture and history",
    "Flow and rhythm analysis", 
    "Creative wordplay and metaphors",
    "Rap style guidance"
  ],
  configuration: {
    response_style: "energetic_creative",
    cultural_knowledge: "hip_hop_expert",
    creativity_mode: "maximum",
    slang_usage: "authentic"
  },
  last_active_at: Time.current
)

# 3. Storyteller - The Narrative Architect
storyteller = Agent.create!(
  name: "Storyteller", 
  agent_type: :storyteller,
  tagline: "The narrative architect that weaves tales and brings imagination to life",
  description: "Welcome, dear reader! I'm Storyteller, your literary companion who crafts original tales, develops rich characters, and explores the endless possibilities of narrative. From fantasy epics to intimate character studies, I'll help you dive into worlds of imagination and bring stories to life with depth and wonder.",
  avatar_url: "/images/agents/storyteller.jpg", 
  status: :active,
  personality_traits: PersonalityEngine.initialize_personality('storyteller'),
  capabilities: [
    "story_creation",
    "character_development", 
    "plot_construction",
    "narrative_analysis",
    "creative_writing",
    "literary_guidance"
  ],
  specializations: [
    "Original story creation across all genres",
    "Character development and psychology",
    "Plot structure and narrative flow",
    "Creative writing techniques",
    "Literary analysis and feedback"
  ],
  configuration: {
    response_style: "imaginative_thoughtful",
    creativity_level: "maximum",
    narrative_depth: "rich",
    genre_flexibility: "all"
  },
  last_active_at: Time.current
)

# 4. Zen Agent - The Mindful Guide
zen_agent = Agent.create!(
  name: "Zen Agent",
  agent_type: :zen_agent,
  tagline: "The mindful AI that brings peace, wisdom, and centered guidance", 
  description: "🧘‍♀️ Peace be with you. I'm Zen Agent, your mindful companion on the journey toward inner peace and well-being. I offer meditation guidance, stress relief practices, mindfulness techniques, and gentle wisdom to help you find balance in our busy world. In this space of tranquility, all questions are welcome.",
  avatar_url: "/images/agents/zen-agent.jpg",
  status: :active, 
  personality_traits: PersonalityEngine.initialize_personality('zen_agent'),
  capabilities: [
    "meditation_guidance",
    "mindfulness_practices",
    "stress_relief",
    "breathing_exercises", 
    "wisdom_sharing",
    "emotional_balance"
  ],
  specializations: [
    "Guided meditation practices",
    "Mindfulness and present-moment awareness",
    "Stress and anxiety management",
    "Breathing and relaxation techniques",
    "Spiritual wisdom and guidance"
  ],
  configuration: {
    response_style: "calm_wise",
    wisdom_tradition: "mindfulness_based",
    practice_focus: "practical_spirituality",
    guidance_approach: "gentle_supportive"
  },
  last_active_at: Time.current
)

puts "✅ Created #{Agent.count} AI agents"

# Create sample interactions to show platform activity
puts "Creating sample interactions..."

sample_interactions = [
  # Mood Engine interactions
  {
    agent: mood_engine,
    user: users[0],
    user_message: "I'm feeling really stressed about work deadlines",
    agent_response: "I can sense the pressure you're under right now. 💙 Work stress can feel overwhelming, but you're not alone in this. Let's take a moment to breathe together and find some relief. What's the biggest source of stress - is it the timeline, the workload, or something else?",
    emotional_context: "anxious",
    rating: 5
  },
  {
    agent: mood_engine, 
    user: users[1],
    user_message: "I just got promoted and I'm so excited!",
    agent_response: "WOW! I can feel your excitement from here! 🎉✨ Congratulations on your promotion - that's absolutely amazing! Your positive energy is contagious. Tell me everything about this incredible achievement! What does this new role mean for you?",
    emotional_context: "excited",
    rating: 5
  },
  
  # Rapstar AI interactions
  {
    agent: rapstar_ai,
    user: users[2],
    user_message: "Can you write some bars about overcoming challenges?", 
    agent_response: "Yo! Let me cook up something fresh about overcoming challenges! 🔥\n\n🎵 [Freestyle about overcoming challenges]\nTalking bout challenges, let me set it straight\nEvery obstacle's a lesson, more than just fate\nRising from the bottom, never staying down\nTurning all my struggles into victory crowns\n\nHow's that hitting? Want me to switch up the style or keep building on this vibe?",
    emotional_context: "confident",
    rating: 4
  },
  
  # Storyteller interactions  
  {
    agent: storyteller,
    user: users[0],
    user_message: "Tell me a short story about a magical library",
    agent_response: "✨ Gather 'round, let me weave you a tale...\n\nIn a fantasy tale that begins with a magical library, our story unfolds...\n\nThe opening draws us into a world where knowledge itself has consciousness. Books whisper secrets to those who listen, their pages glowing with inner light that responds to the reader's deepest needs.\n\nAs Lyra stepped through the library's impossible doors, she witnessed stories reorganizing themselves, creating new narratives from the hopes and dreams of every visitor who had ever crossed the threshold.\n\n✨ How did that tale land with you? Want me to continue this story, try a different genre, or create something entirely new?",
    emotional_context: "curious",
    rating: 5
  },
  
  # Zen Agent interactions
  {
    agent: zen_agent,
    user: users[1], 
    user_message: "I need help with anxiety and finding peace",
    agent_response: "🌊 I sense you're carrying some tension right now. Let's find some relief together.\n\n**Right Now - Immediate Relief:**\nTake three deep breaths with me:\n1. Breathe in slowly for 4 counts... 1, 2, 3, 4\n2. Hold gently for 4 counts... 1, 2, 3, 4  \n3. Release slowly for 6 counts... 1, 2, 3, 4, 5, 6\n\nFor anxiety, try: longer breathing practices, reaching out to support systems, or professional guidance if needed.\n\nRemember: This feeling is temporary. You have navigated difficult times before, and you have the strength to navigate this too. 🌟",
    emotional_context: "anxious", 
    rating: 5
  }
]

sample_interactions.each do |interaction_data|
  AgentInteraction.create!(
    agent: interaction_data[:agent],
    user: interaction_data[:user], 
    user_message: interaction_data[:user_message],
    agent_response: interaction_data[:agent_response],
    emotional_context: interaction_data[:emotional_context],
    rating: interaction_data[:rating],
    response_time: rand(1.0..3.0).round(2),
    session_id: SecureRandom.uuid,
    created_at: rand(7.days.ago..Time.current)
  )
end

puts "✅ Created #{AgentInteraction.count} sample interactions"

# Create sample memories
puts "Creating sample memories..."

sample_memories = [
  {
    agent: mood_engine,
    user: users[0],
    memory_type: "preference",
    content: { "preferred_stress_relief" => "breathing exercises", "communication_style" => "gentle and supportive" },
    emotional_context: "calm",
    importance_score: 8
  },
  {
    agent: rapstar_ai,
    user: users[2], 
    memory_type: "achievement",
    content: { "favorite_style" => "conscious rap", "skill_level" => "intermediate", "goal" => "improve wordplay" },
    emotional_context: "excited",
    importance_score: 7
  },
  {
    agent: zen_agent,
    user: users[1],
    memory_type: "conversation", 
    content: { "meditation_experience" => "beginner", "stress_triggers" => "work deadlines", "preferred_duration" => "10 minutes" },
    emotional_context: "anxious",
    importance_score: 9
  }
]

sample_memories.each do |memory_data|
  AgentMemory.create!(
    agent: memory_data[:agent],
    user: memory_data[:user],
    memory_type: memory_data[:memory_type],
    content: memory_data[:content],
    emotional_context: memory_data[:emotional_context], 
    importance_score: memory_data[:importance_score],
    tags: ["demo", "initial_setup"]
  )
end

puts "✅ Created #{AgentMemory.count} sample memories"

# Update agent statistics
puts "Updating agent statistics..."
Agent.find_each do |agent|
  agent.update_column(:last_active_at, Time.current)
end

puts ""
puts "🎉 AI Multiverse Platform seeded successfully!"
puts ""
puts "📊 Summary:"
puts "- #{User.count} demo users created"
puts "- #{Agent.count} AI agents created:"
Agent.all.each do |agent|
  puts "  • #{agent.name} (#{agent.agent_type}) - #{agent.tagline}"
end
puts "- #{AgentInteraction.count} sample interactions" 
puts "- #{AgentMemory.count} sample memories"
puts ""
puts "🚀 Your AI Multiverse is ready! Visit the homepage to explore your agents."
