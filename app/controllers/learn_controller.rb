class LearnController < ApplicationController
  def index
    @featured_tutorials = get_featured_tutorials
    @learning_paths = get_learning_paths
    @popular_tutorials = get_popular_tutorials
    @skill_categories = get_skill_categories
    @recent_additions = get_recent_additions
  end

  def tutorials
    @all_tutorials = get_all_tutorials
    @categories = get_tutorial_categories
    @difficulty_levels = get_difficulty_levels
    @filters = params[:filters] || {}
  end

  def tutorial
    @tutorial = get_tutorial_by_id(params[:id])
    @related_tutorials = get_related_tutorials(@tutorial)
    @tutorial_progress = get_tutorial_progress(params[:id])
    @next_tutorial = get_next_tutorial(@tutorial)
  end

  def paths
    @all_paths = get_all_learning_paths
    @path_categories = get_path_categories
  end

  def path
    @path = get_learning_path_by_id(params[:id])
    @path_tutorials = get_path_tutorials(@path)
    @path_progress = get_path_progress(params[:id])
    @estimated_completion = calculate_path_completion_time(@path)
  end

  private

  def get_featured_tutorials
    [
      {
        id: 1,
        title: 'Building Your First AI Customer Service Bot',
        description: 'Learn to create an intelligent customer service bot using NeoChat and EmotiSense',
        difficulty: 'Intermediate',
        duration: '45 min',
        image: 'customer-service-bot.jpg',
        technologies: %w[NeoChat EmotiSense Webhooks],
        rating: 4.9,
        students: 1247
      },
      {
        id: 2,
        title: 'AI Content Marketing Automation',
        description: 'Automate your content creation workflow with ContentCrafter and scheduling tools',
        difficulty: 'Advanced',
        duration: '90 min',
        image: 'content-automation.jpg',
        technologies: %w[ContentCrafter APIs Automation],
        rating: 4.8,
        students: 892
      },
      {
        id: 3,
        title: 'Real-time Video Processing with CineGen',
        description: "Process and enhance videos in real-time using CineGen's advanced capabilities",
        difficulty: 'Expert',
        duration: '120 min',
        image: 'video-processing.jpg',
        technologies: ['CineGen', 'Streaming', 'Media APIs'],
        rating: 4.9,
        students: 634
      }
    ]
  end

  def get_learning_paths
    [
      {
        id: 1,
        title: 'AI Development Fundamentals',
        description: 'Master the basics of AI development with Phantom AI platform',
        level: 'Beginner',
        tutorials: 8,
        duration: '6 hours',
        students: 2340,
        color: 'emerald',
        icon: '🚀'
      },
      {
        id: 2,
        title: 'Conversational AI Mastery',
        description: 'Build sophisticated chatbots and conversational interfaces',
        level: 'Intermediate',
        tutorials: 12,
        duration: '10 hours',
        students: 1567,
        color: 'blue',
        icon: '💬'
      },
      {
        id: 3,
        title: 'Enterprise AI Integration',
        description: 'Scale AI solutions for enterprise environments',
        level: 'Advanced',
        tutorials: 15,
        duration: '18 hours',
        students: 834,
        color: 'purple',
        icon: '🏢'
      },
      {
        id: 4,
        title: 'Creative AI Applications',
        description: 'Explore artistic and creative uses of AI technology',
        level: 'Intermediate',
        tutorials: 10,
        duration: '8 hours',
        students: 1092,
        color: 'pink',
        icon: '🎨'
      }
    ]
  end

  def get_popular_tutorials
    [
      {
        id: 4,
        title: 'API Authentication Deep Dive',
        views: 15_420,
        rating: 4.7,
        difficulty: 'Beginner'
      },
      {
        id: 5,
        title: 'Webhook Integration Patterns',
        views: 12_850,
        rating: 4.8,
        difficulty: 'Intermediate'
      },
      {
        id: 6,
        title: 'Multi-Agent Orchestration',
        views: 11_200,
        rating: 4.9,
        difficulty: 'Advanced'
      },
      {
        id: 7,
        title: 'Error Handling Best Practices',
        views: 9800,
        rating: 4.6,
        difficulty: 'Intermediate'
      }
    ]
  end

  def get_skill_categories
    [
      {
        name: 'API Development',
        count: 23,
        icon: '🔌',
        color: 'blue'
      },
      {
        name: 'Machine Learning',
        count: 18,
        icon: '🌌',
        color: 'purple'
      },
      {
        name: 'Web Development',
        count: 15,
        icon: '🌐',
        color: 'green'
      },
      {
        name: 'Mobile Development',
        count: 12,
        icon: '📱',
        color: 'orange'
      },
      {
        name: 'Data Science',
        count: 20,
        icon: '📊',
        color: 'cyan'
      },
      {
        name: 'DevOps',
        count: 14,
        icon: '⚙️',
        color: 'gray'
      }
    ]
  end

  def get_recent_additions
    [
      {
        id: 8,
        title: 'Advanced EmotiSense Techniques',
        added: '3 days ago',
        difficulty: 'Advanced'
      },
      {
        id: 9,
        title: 'CineGen Performance Optimization',
        added: '1 week ago',
        difficulty: 'Expert'
      },
      {
        id: 10,
        title: 'Building AI-Powered Analytics Dashboard',
        added: '2 weeks ago',
        difficulty: 'Intermediate'
      }
    ]
  end

  def get_all_tutorials
    [
      {
        id: 1,
        title: 'Building Your First AI Customer Service Bot',
        description: 'Learn to create an intelligent customer service bot',
        difficulty: 'Intermediate',
        duration: '45 min',
        category: 'Conversational AI',
        technologies: %w[NeoChat EmotiSense],
        rating: 4.9,
        students: 1247,
        free: true
      },
      {
        id: 2,
        title: 'AI Content Marketing Automation',
        description: 'Automate your content creation workflow',
        difficulty: 'Advanced',
        duration: '90 min',
        category: 'Content Creation',
        technologies: ['ContentCrafter'],
        rating: 4.8,
        students: 892,
        free: false
      },
      {
        id: 3,
        title: 'Real-time Video Processing with CineGen',
        description: 'Process and enhance videos in real-time',
        difficulty: 'Expert',
        duration: '120 min',
        category: 'Video Processing',
        technologies: ['CineGen'],
        rating: 4.9,
        students: 634,
        free: false
      },
      {
        id: 4,
        title: 'API Authentication Deep Dive',
        description: 'Master API security and authentication',
        difficulty: 'Beginner',
        duration: '30 min',
        category: 'API Development',
        technologies: ['REST APIs'],
        rating: 4.7,
        students: 2340,
        free: true
      },
      {
        id: 5,
        title: 'Webhook Integration Patterns',
        description: 'Implement real-time event handling',
        difficulty: 'Intermediate',
        duration: '60 min',
        category: 'API Development',
        technologies: ['Webhooks'],
        rating: 4.8,
        students: 1567,
        free: true
      }
    ]
  end

  def get_tutorial_categories
    [
      'All Categories',
      'API Development',
      'Conversational AI',
      'Content Creation',
      'Video Processing',
      'Data Analysis',
      'Machine Learning',
      'Web Development',
      'Mobile Development'
    ]
  end

  def get_difficulty_levels
    ['All Levels', 'Beginner', 'Intermediate', 'Advanced', 'Expert']
  end

  def get_tutorial_by_id(id)
    {
      id: id.to_i,
      title: 'Building Your First AI Customer Service Bot',
      description: "In this comprehensive tutorial, you'll learn how to build an intelligent customer service bot that can handle complex customer inquiries using the power of AI.",
      difficulty: 'Intermediate',
      duration: '45 min',
      category: 'Conversational AI',
      technologies: %w[NeoChat EmotiSense Webhooks],
      rating: 4.9,
      students: 1247,
      instructor: {
        name: 'Sarah Chen',
        title: 'AI Solutions Architect',
        avatar: 'sarah-chen.jpg',
        bio: 'Sarah has 8+ years of experience building AI systems for enterprise customers.'
      },
      chapters: [
        {
          title: 'Introduction and Setup',
          duration: '8 min',
          completed: false
        },
        {
          title: 'Understanding Customer Intent',
          duration: '12 min',
          completed: false
        },
        {
          title: 'Implementing Emotion Analysis',
          duration: '15 min',
          completed: false
        },
        {
          title: 'Building Response Logic',
          duration: '10 min',
          completed: false
        }
      ],
      prerequisites: [
        'Basic understanding of APIs',
        'Familiarity with JavaScript or Python',
        'Phantom AI account with API access'
      ],
      learning_objectives: [
        'Set up NeoChat for conversational AI',
        'Integrate EmotiSense for emotion detection',
        'Handle complex customer scenarios',
        'Deploy and monitor your bot'
      ],
      resources: [
        {
          title: 'Sample Code Repository',
          type: 'github',
          url: 'https://github.com/phantom-ai/customer-service-bot'
        },
        {
          title: 'API Reference Documentation',
          type: 'docs',
          url: '/docs/api'
        },
        {
          title: 'Community Discussion',
          type: 'forum',
          url: '/community/forum/tutorials'
        }
      ]
    }
  end

  def get_related_tutorials(_tutorial)
    [
      {
        id: 11,
        title: 'Advanced NeoChat Techniques',
        difficulty: 'Advanced',
        duration: '60 min'
      },
      {
        id: 12,
        title: 'EmotiSense Integration Patterns',
        difficulty: 'Intermediate',
        duration: '35 min'
      },
      {
        id: 13,
        title: 'Bot Performance Optimization',
        difficulty: 'Advanced',
        duration: '50 min'
      }
    ]
  end

  def get_tutorial_progress(_tutorial_id)
    {
      completed_chapters: 0,
      total_chapters: 4,
      completion_percentage: 0,
      time_spent: '0 min',
      last_accessed: nil
    }
  end

  def get_next_tutorial(_tutorial)
    {
      id: 14,
      title: 'Advanced Conversation Flow Design',
      difficulty: 'Advanced',
      duration: '75 min'
    }
  end

  def get_all_learning_paths
    [
      {
        id: 1,
        title: 'AI Development Fundamentals',
        description: 'Master the basics of AI development with Phantom AI platform',
        level: 'Beginner',
        tutorials: 8,
        duration: '6 hours',
        students: 2340,
        color: 'emerald',
        icon: '🚀',
        skills: ['API Basics', 'Authentication', 'First AI Agent']
      },
      {
        id: 2,
        title: 'Conversational AI Mastery',
        description: 'Build sophisticated chatbots and conversational interfaces',
        level: 'Intermediate',
        tutorials: 12,
        duration: '10 hours',
        students: 1567,
        color: 'blue',
        icon: '💬',
        skills: ['NeoChat', 'Dialog Management', 'Context Handling']
      },
      {
        id: 3,
        title: 'Enterprise AI Integration',
        description: 'Scale AI solutions for enterprise environments',
        level: 'Advanced',
        tutorials: 15,
        duration: '18 hours',
        students: 834,
        color: 'purple',
        icon: '🏢',
        skills: %w[Scalability Security Monitoring]
      },
      {
        id: 4,
        title: 'Creative AI Applications',
        description: 'Explore artistic and creative uses of AI technology',
        level: 'Intermediate',
        tutorials: 10,
        duration: '8 hours',
        students: 1092,
        color: 'pink',
        icon: '🎨',
        skills: ['CineGen', 'ContentCrafter', 'Creative Workflows']
      }
    ]
  end

  def get_path_categories
    ['All Categories', 'Development', 'Business', 'Creative', 'Technical', 'Enterprise']
  end

  def get_learning_path_by_id(id)
    paths = get_all_learning_paths
    path = paths.find { |p| p[:id] == id.to_i }

    if path
      path.merge({
                   overview: get_path_overview(id),
                   curriculum: get_path_curriculum(id),
                   instructors: get_path_instructors(id),
                   certificate: get_path_certificate_info(id)
                 })
    else
      {}
    end
  end

  def get_path_overview(path_id)
    case path_id.to_i
    when 1
      "This foundational path introduces you to the core concepts of AI development using the Phantom AI platform. You'll start with basic API usage and gradually build up to creating your first intelligent applications."
    when 2
      'Dive deep into conversational AI and learn to build sophisticated chatbots that can handle complex interactions, maintain context, and provide personalized responses.'
    when 3
      'Learn how to design, implement, and scale AI solutions for enterprise environments, including security best practices, monitoring, and integration patterns.'
    when 4
      'Explore the creative potential of AI through hands-on projects involving content generation, video processing, and artistic applications.'
    else
      'A comprehensive learning path designed to advance your AI development skills.'
    end
  end

  def get_path_curriculum(path_id)
    case path_id.to_i
    when 1
      [
        {
          module: 'Getting Started',
          tutorials: [
            { title: 'Platform Overview', duration: '15 min', free: true },
            { title: 'API Authentication', duration: '20 min', free: true },
            { title: 'Your First API Call', duration: '25 min', free: true }
          ]
        },
        {
          module: 'Core Concepts',
          tutorials: [
            { title: 'Understanding AI Agents', duration: '30 min', free: false },
            { title: 'Request/Response Patterns', duration: '25 min', free: false }
          ]
        },
        {
          module: 'Building Applications',
          tutorials: [
            { title: 'Simple Chatbot', duration: '45 min', free: false },
            { title: 'Error Handling', duration: '30 min', free: false },
            { title: 'Deployment Basics', duration: '40 min', free: false }
          ]
        }
      ]
    when 2
      [
        {
          module: 'Conversational AI Fundamentals',
          tutorials: [
            { title: 'NeoChat Introduction', duration: '20 min', free: true },
            { title: 'Dialog Design Principles', duration: '35 min', free: false },
            { title: 'Context Management', duration: '40 min', free: false }
          ]
        },
        {
          module: 'Advanced Techniques',
          tutorials: [
            { title: 'Multi-turn Conversations', duration: '50 min', free: false },
            { title: 'Personality and Tone', duration: '30 min', free: false },
            { title: 'Integration with EmotiSense', duration: '45 min', free: false }
          ]
        },
        {
          module: 'Production Deployment',
          tutorials: [
            { title: 'Scaling Conversations', duration: '60 min', free: false },
            { title: 'Analytics and Monitoring', duration: '40 min', free: false },
            { title: 'Continuous Improvement', duration: '35 min', free: false }
          ]
        }
      ]
    else
      []
    end
  end

  def get_path_instructors(_path_id)
    [
      {
        name: 'Dr. Alex Rodriguez',
        title: 'Lead AI Researcher',
        avatar: 'alex-rodriguez.jpg',
        experience: '10+ years in AI/ML',
        specialties: ['Machine Learning', 'NLP', 'Computer Vision']
      },
      {
        name: 'Sarah Chen',
        title: 'AI Solutions Architect',
        avatar: 'sarah-chen.jpg',
        experience: '8+ years in enterprise AI',
        specialties: ['Enterprise Integration', 'Scalability', 'API Design']
      }
    ]
  end

  def get_path_certificate_info(_path_id)
    {
      available: true,
      requirements: [
        'Complete all tutorials with 80% or higher score',
        'Submit final project',
        'Pass certification exam'
      ],
      benefits: [
        'Industry-recognized certification',
        'LinkedIn profile badge',
        'Access to exclusive job board',
        'Priority technical support'
      ]
    }
  end

  def get_path_tutorials(path)
    curriculum = get_path_curriculum(path[:id])
    tutorials = []

    curriculum.each do |module_data|
      module_data[:tutorials].each_with_index do |tutorial, _index|
        tutorials << {
          id: "#{path[:id]}-#{tutorials.length + 1}",
          title: tutorial[:title],
          duration: tutorial[:duration],
          module: module_data[:module],
          order: tutorials.length + 1,
          free: tutorial[:free],
          completed: false
        }
      end
    end

    tutorials
  end

  def get_path_progress(_path_id)
    {
      completed_tutorials: 0,
      total_tutorials: 8,
      completion_percentage: 0,
      time_spent: '0 hours',
      estimated_remaining: '6 hours',
      last_accessed: nil,
      current_tutorial: nil
    }
  end

  def calculate_path_completion_time(path)
    "#{path[:duration]} at 2-3 hours per week"
  end
end
