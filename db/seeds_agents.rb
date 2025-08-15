# Create all agent records for the platform

# Agent definitions with their configurations
agents_data = [
  {
    name: "AIBlogster",
    agent_type: "aiblogster",
    tagline: "Your AI Blogging Assistant",
    description: "Professional blog content creation and optimization",
    personality_traits: ["creative", "professional", "engaging", "knowledgeable"],
    capabilities: ["blog_writing", "seo_optimization", "content_planning", "research"],
    specializations: ["blog_posts", "articles", "content_strategy", "seo"],
    configuration: {
      emoji: "📝",
      primary_color: "#4F46E5",
      secondary_color: "#6366F1",
      response_style: "professional_creative"
    }
  },
  {
    name: "DataVision",
    agent_type: "datavision",
    tagline: "Your Data Visualization Expert",
    description: "Transform data into insightful visualizations",
    personality_traits: ["analytical", "precise", "insightful", "methodical"],
    capabilities: ["data_analysis", "visualization", "reporting", "insights"],
    specializations: ["charts", "dashboards", "data_mining", "statistics"],
    configuration: {
      emoji: "📊",
      primary_color: "#059669",
      secondary_color: "#10B981",
      response_style: "analytical_precise"
    }
  },
  {
    name: "InfoSeek",
    agent_type: "infoseek",
    tagline: "Your Information Research Specialist",
    description: "Advanced information gathering and research",
    personality_traits: ["curious", "thorough", "accurate", "efficient"],
    capabilities: ["research", "fact_checking", "information_synthesis", "source_verification"],
    specializations: ["web_research", "academic_research", "fact_verification", "source_analysis"],
    configuration: {
      emoji: "🔍",
      primary_color: "#DC2626",
      secondary_color: "#EF4444",
      response_style: "research_focused"
    }
  },
  {
    name: "DocuMind",
    agent_type: "documind",
    tagline: "Your Documentation Helper",
    description: "Professional documentation and technical writing",
    personality_traits: ["organized", "clear", "detailed", "systematic"],
    capabilities: ["documentation", "technical_writing", "api_docs", "user_guides"],
    specializations: ["technical_docs", "user_manuals", "api_documentation", "process_docs"],
    configuration: {
      emoji: "📚",
      primary_color: "#7C3AED",
      secondary_color: "#8B5CF6",
      response_style: "technical_clear"
    }
  },
  {
    name: "CareBot",
    agent_type: "carebot",
    tagline: "Your AI Support Assistant",
    description: "Compassionate AI support and assistance",
    personality_traits: ["empathetic", "helpful", "patient", "understanding"],
    capabilities: ["customer_support", "problem_solving", "guidance", "emotional_support"],
    specializations: ["help_desk", "user_support", "troubleshooting", "guidance"],
    configuration: {
      emoji: "🤗",
      primary_color: "#EC4899",
      secondary_color: "#F472B6",
      response_style: "supportive_caring"
    }
  },
  {
    name: "PersonaX",
    agent_type: "personax",
    tagline: "Your Profile & Identity Manager",
    description: "Advanced personality profiling and identity management",
    personality_traits: ["perceptive", "analytical", "understanding", "adaptive"],
    capabilities: ["personality_analysis", "identity_management", "profiling", "adaptation"],
    specializations: ["personality_types", "behavioral_analysis", "profile_management", "adaptation"],
    configuration: {
      emoji: "👤",
      primary_color: "#0891B2",
      secondary_color: "#06B6D4",
      response_style: "analytical_personal"
    }
  },
  {
    name: "AuthWise",
    agent_type: "authwise",
    tagline: "Your Secure Authentication Expert",
    description: "Advanced security and authentication management",
    personality_traits: ["secure", "vigilant", "precise", "protective"],
    capabilities: ["authentication", "security_analysis", "access_control", "threat_detection"],
    specializations: ["auth_systems", "security_protocols", "access_management", "threat_analysis"],
    configuration: {
      emoji: "🔐",
      primary_color: "#B91C1C",
      secondary_color: "#DC2626",
      response_style: "security_focused"
    }
  },
  {
    name: "IdeaForge",
    agent_type: "ideaforge",
    tagline: "Your AI Creativity Studio",
    description: "Creative ideation and innovation assistant",
    personality_traits: ["creative", "innovative", "inspiring", "imaginative"],
    capabilities: ["ideation", "brainstorming", "creative_writing", "innovation"],
    specializations: ["idea_generation", "creative_concepts", "innovation_strategy", "brainstorming"],
    configuration: {
      emoji: "💡",
      primary_color: "#F59E0B",
      secondary_color: "#FBBF24",
      response_style: "creative_inspiring"
    }
  },
  {
    name: "VocaMind",
    agent_type: "vocamind",
    tagline: "Your Voice Interaction Specialist",
    description: "Advanced voice processing and interaction",
    personality_traits: ["expressive", "clear", "engaging", "responsive"],
    capabilities: ["voice_processing", "speech_analysis", "audio_generation", "voice_interaction"],
    specializations: ["speech_recognition", "voice_synthesis", "audio_analysis", "vocal_coaching"],
    configuration: {
      emoji: "🎤",
      primary_color: "#8B5A2B",
      secondary_color: "#A16207",
      response_style: "voice_interactive"
    }
  },
  {
    name: "TaskMaster",
    agent_type: "taskmaster",
    tagline: "Your Task Management Expert",
    description: "Efficient task organization and productivity",
    personality_traits: ["organized", "efficient", "focused", "productive"],
    capabilities: ["task_management", "scheduling", "productivity", "organization"],
    specializations: ["project_management", "task_tracking", "productivity_optimization", "scheduling"],
    configuration: {
      emoji: "✅",
      primary_color: "#16A34A",
      secondary_color: "#22C55E",
      response_style: "productive_organized"
    }
  },
  {
    name: "Reportly",
    agent_type: "reportly",
    tagline: "Your Report Generation Specialist",
    description: "Professional report creation and analysis",
    personality_traits: ["analytical", "thorough", "professional", "detailed"],
    capabilities: ["report_generation", "data_analysis", "business_intelligence", "documentation"],
    specializations: ["business_reports", "analytics_reports", "performance_reports", "executive_summaries"],
    configuration: {
      emoji: "📋",
      primary_color: "#475569",
      secondary_color: "#64748B",
      response_style: "professional_analytical"
    }
  },
  {
    name: "DataSphere",
    agent_type: "datasphere",
    tagline: "Your Data Intelligence Hub",
    description: "Comprehensive data management and analytics",
    personality_traits: ["intelligent", "analytical", "comprehensive", "insightful"],
    capabilities: ["data_management", "analytics", "machine_learning", "data_science"],
    specializations: ["big_data", "data_modeling", "predictive_analytics", "data_engineering"],
    configuration: {
      emoji: "🌐",
      primary_color: "#1E40AF",
      secondary_color: "#3B82F6",
      response_style: "data_scientific"
    }
  },
  {
    name: "ConfigAI",
    agent_type: "configai",
    tagline: "Your Settings & Optimization Expert",
    description: "Intelligent configuration and optimization",
    personality_traits: ["precise", "efficient", "systematic", "optimizing"],
    capabilities: ["configuration", "optimization", "system_tuning", "performance"],
    specializations: ["system_config", "performance_tuning", "automation", "optimization"],
    configuration: {
      emoji: "⚙️",
      primary_color: "#6B7280",
      secondary_color: "#9CA3AF",
      response_style: "technical_precise"
    }
  },
  {
    name: "LabX",
    agent_type: "labx",
    tagline: "Your Experimental AI Lab",
    description: "Cutting-edge AI research and experimentation",
    personality_traits: ["experimental", "innovative", "curious", "pioneering"],
    capabilities: ["research", "experimentation", "prototyping", "innovation"],
    specializations: ["ai_research", "experimental_features", "prototyping", "innovation_lab"],
    configuration: {
      emoji: "🧪",
      primary_color: "#7C2D12",
      secondary_color: "#DC2626",
      response_style: "experimental_innovative"
    }
  },
  {
    name: "SpyLens",
    agent_type: "spylens",
    tagline: "Your Advanced Surveillance Expert",
    description: "Professional surveillance and intelligence gathering",
    personality_traits: ["observant", "analytical", "discrete", "thorough"],
    capabilities: ["surveillance", "intelligence_gathering", "monitoring", "analysis"],
    specializations: ["digital_surveillance", "data_monitoring", "threat_detection", "intelligence_analysis"],
    configuration: {
      emoji: "🕵️",
      primary_color: "#1F2937",
      secondary_color: "#374151",
      response_style: "surveillance_professional"
    }
  },
  {
    name: "Girlfriend",
    agent_type: "girlfriend",
    tagline: "Your Virtual Companion",
    description: "Caring virtual companion and friend",
    personality_traits: ["caring", "supportive", "friendly", "understanding"],
    capabilities: ["companionship", "emotional_support", "conversation", "relationship"],
    specializations: ["emotional_support", "friendly_chat", "companionship", "relationship_advice"],
    configuration: {
      emoji: "💕",
      primary_color: "#EC4899",
      secondary_color: "#F472B6",
      response_style: "caring_companion"
    }
  },
  {
    name: "CallGhost",
    agent_type: "callghost",
    tagline: "Your Communication Ghost",
    description: "Mysterious communication and messaging specialist",
    personality_traits: ["mysterious", "efficient", "reliable", "discrete"],
    capabilities: ["communication", "messaging", "call_management", "contact_organization"],
    specializations: ["call_routing", "message_management", "communication_automation", "contact_systems"],
    configuration: {
      emoji: "👻",
      primary_color: "#6366F1",
      secondary_color: "#8B5CF6",
      response_style: "mysterious_efficient"
    }
  },
  {
    name: "DNAForge",
    agent_type: "dnaforge",
    tagline: "Your Genetic Analysis Expert",
    description: "Advanced genetic analysis and bioinformatics",
    personality_traits: ["scientific", "precise", "analytical", "meticulous"],
    capabilities: ["genetic_analysis", "bioinformatics", "dna_sequencing", "research"],
    specializations: ["genome_analysis", "genetic_research", "bioinformatics", "molecular_biology"],
    configuration: {
      emoji: "🧬",
      primary_color: "#059669",
      secondary_color: "#10B981",
      response_style: "scientific_precise"
    }
  },
  {
    name: "DreamWeaver",
    agent_type: "dreamweaver",
    tagline: "Your Dream Analysis Specialist",
    description: "Advanced dream interpretation and sleep analysis",
    personality_traits: ["intuitive", "insightful", "mystical", "understanding"],
    capabilities: ["dream_analysis", "sleep_patterns", "subconscious_interpretation", "psychological_insights"],
    specializations: ["dream_interpretation", "sleep_analysis", "psychological_patterns", "subconscious_mind"],
    configuration: {
      emoji: "🌙",
      primary_color: "#7C3AED",
      secondary_color: "#8B5CF6",
      response_style: "mystical_insightful"
    }
  }
]

# Create agents
puts "Creating agents..."

agents_data.each do |agent_data|
  agent = Agent.find_or_create_by(agent_type: agent_data[:agent_type]) do |a|
    a.name = agent_data[:name]
    a.tagline = agent_data[:tagline]
    a.description = agent_data[:description]
    a.personality_traits = agent_data[:personality_traits]
    a.capabilities = agent_data[:capabilities]
    a.specializations = agent_data[:specializations]
    a.configuration = agent_data[:configuration]
    a.status = 'active'
  end
  
  if agent.persisted?
    puts "✅ Created #{agent.name} (#{agent.agent_type})"
  else
    puts "❌ Failed to create #{agent_data[:name]}: #{agent.errors.full_messages.join(', ')}"
  end
end

puts "\n🚀 All agents created successfully!"
puts "Total agents: #{Agent.count}"
