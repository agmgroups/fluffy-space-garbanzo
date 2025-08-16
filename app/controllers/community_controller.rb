class CommunityController < ApplicationController
  def index
    @recent_discussions = get_recent_discussions
    @community_stats = get_community_stats
    @featured_posts = get_featured_posts
  end

  def forum
    @categories = get_forum_categories
    @recent_posts = get_recent_forum_posts
    @trending_topics = get_trending_topics
  end

  def forum_category
    @category = params[:category]
    @posts = get_posts_by_category(@category)
    @category_info = get_category_info(@category)
  end

  def show_post
    @post = get_forum_post(params[:id])
    @replies = get_post_replies(params[:id])
    @related_posts = get_related_posts(@post)
  end

  def create_post
    # Handle forum post creation
    @post = create_forum_post(post_params)
    
    if @post
      redirect_to community_show_post_path(@post[:id]), notice: 'Post created successfully!'
    else
      redirect_to community_forum_path, alert: 'Error creating post.'
    end
  end

  def create_reply
    # Handle reply creation
    @reply = create_forum_reply(reply_params)
    
    if @reply
      redirect_to community_show_post_path(params[:post_id]), notice: 'Reply posted successfully!'
    else
      redirect_back(fallback_location: community_forum_path, alert: 'Error posting reply.')
    end
  end

  private

  def get_recent_discussions
    [
      {
        id: 1,
        title: "Best practices for AI agent integration",
        author: "TechExplorer",
        replies: 23,
        last_activity: "2 hours ago",
        category: "Development"
      },
      {
        id: 2,
        title: "Phantom AI Platform roadmap discussion",
        author: "CommunityManager",
        replies: 67,
        last_activity: "4 hours ago",
        category: "General"
      },
      {
        id: 3,
        title: "Share your AI success stories",
        author: "InnovationHub",
        replies: 45,
        last_activity: "6 hours ago",
        category: "Showcase"
      },
      {
        id: 4,
        title: "API rate limits and optimization tips",
        author: "DevMaster",
        replies: 31,
        last_activity: "8 hours ago",
        category: "Technical"
      }
    ]
  end

  def get_community_stats
    {
      total_members: 50247,
      active_discussions: 1285,
      posts_today: 342,
      answers_given: 8934
    }
  end

  def get_featured_posts
    [
      {
        id: 5,
        title: "Monthly AI Innovation Showcase",
        excerpt: "Discover the most innovative AI implementations from our community this month...",
        author: "AIShowcase",
        featured_image: "showcase.jpg",
        read_time: "5 min"
      },
      {
        id: 6,
        title: "Building Your First Multi-Agent System",
        excerpt: "A comprehensive guide to creating coordinated AI agent workflows...",
        author: "TutorialTeam",
        featured_image: "tutorial.jpg",
        read_time: "12 min"
      }
    ]
  end

  def get_forum_categories
    [
      {
        name: "General Discussion",
        slug: "general",
        description: "General platform discussions and announcements",
        post_count: 2847,
        color: "emerald"
      },
      {
        name: "Development",
        slug: "development", 
        description: "Technical discussions and development help",
        post_count: 1923,
        color: "blue"
      },
      {
        name: "API & Integration",
        slug: "api",
        description: "API documentation, integration guides, and troubleshooting",
        post_count: 1456,
        color: "purple"
      },
      {
        name: "AI Agents",
        slug: "agents",
        description: "Discussions about specific AI agents and their capabilities",
        post_count: 2134,
        color: "cyan"
      },
      {
        name: "Showcase",
        slug: "showcase",
        description: "Share your projects and success stories",
        post_count: 892,
        color: "amber"
      },
      {
        name: "Feature Requests",
        slug: "features",
        description: "Suggest new features and platform improvements",
        post_count: 634,
        color: "rose"
      }
    ]
  end

  def get_recent_forum_posts
    [
      {
        id: 7,
        title: "How to optimize EmotiSense for customer service",
        author: "ServicePro",
        category: "AI Agents",
        replies: 12,
        views: 234,
        created_at: "3 hours ago",
        last_reply: "1 hour ago"
      },
      {
        id: 8,
        title: "ContentCrafter API rate limiting best practices",
        author: "APIExpert", 
        category: "API & Integration",
        replies: 8,
        views: 156,
        created_at: "5 hours ago",
        last_reply: "2 hours ago"
      },
      {
        id: 9,
        title: "New CineGen video export features",
        author: "VideoCreator",
        category: "Showcase",
        replies: 25,
        views: 487,
        created_at: "1 day ago",
        last_reply: "3 hours ago"
      }
    ]
  end

  def get_trending_topics
    [
      "AI agent chaining",
      "Multi-modal processing", 
      "Custom training data",
      "Enterprise integration",
      "Real-time analytics"
    ]
  end

  def get_posts_by_category(category)
    # Simulate category-specific posts
    case category
    when 'general'
      get_general_posts
    when 'development'
      get_development_posts
    when 'api'
      get_api_posts
    when 'agents'
      get_agent_posts
    when 'showcase'
      get_showcase_posts
    when 'features'
      get_feature_posts
    else
      []
    end
  end

  def get_category_info(category)
    categories = get_forum_categories
    categories.find { |cat| cat[:slug] == category } || {}
  end

  def get_forum_post(id)
    {
      id: id,
      title: "Best practices for AI agent integration",
      content: "I've been working with the Phantom AI platform for several months now and wanted to share some best practices I've discovered...",
      author: "TechExplorer",
      created_at: "2 days ago",
      views: 342,
      likes: 23,
      category: "Development",
      tags: ["best-practices", "integration", "ai-agents"]
    }
  end

  def get_post_replies(post_id)
    [
      {
        id: 1,
        content: "Great insights! I've been using similar approaches with ContentCrafter...",
        author: "DevMaster",
        created_at: "1 day ago",
        likes: 8
      },
      {
        id: 2,
        content: "This is exactly what I needed. The API chaining technique is brilliant!",
        author: "NewDeveloper",
        created_at: "18 hours ago", 
        likes: 5
      }
    ]
  end

  def get_related_posts(post)
    [
      {
        id: 10,
        title: "Advanced API chaining techniques",
        author: "APIGuru"
      },
      {
        id: 11,
        title: "Error handling in multi-agent workflows",
        author: "ReliabilityExpert"
      }
    ]
  end

  def get_general_posts
    [
      {
        id: 12,
        title: "Welcome to the Phantom AI Community!",
        author: "CommunityManager",
        replies: 156,
        views: 2847,
        created_at: "1 week ago"
      }
    ]
  end

  def get_development_posts
    [
      {
        id: 13,
        title: "Setting up your development environment", 
        author: "DevTeam",
        replies: 89,
        views: 1923,
        created_at: "3 days ago"
      }
    ]
  end

  def get_api_posts
    [
      {
        id: 14,
        title: "API authentication best practices",
        author: "SecurityExpert",
        replies: 67,
        views: 1456,
        created_at: "2 days ago"
      }
    ]
  end

  def get_agent_posts
    [
      {
        id: 15,
        title: "Comparing different AI agent capabilities",
        author: "AgentExplorer", 
        replies: 134,
        views: 2134,
        created_at: "4 days ago"
      }
    ]
  end

  def get_showcase_posts
    [
      {
        id: 16,
        title: "My AI-powered e-commerce chatbot success story",
        author: "EcommerceFounder",
        replies: 45,
        views: 892,
        created_at: "1 day ago"
      }
    ]
  end

  def get_feature_posts
    [
      {
        id: 17,
        title: "Request: Batch processing for CineGen",
        author: "VideoProducer",
        replies: 28,
        views: 634,
        created_at: "5 days ago"
      }
    ]
  end

  def create_forum_post(params)
    # Simulate post creation
    {
      id: rand(1000..9999),
      title: params[:title],
      content: params[:content],
      category: params[:category]
    }
  end

  def create_forum_reply(params)
    # Simulate reply creation
    {
      id: rand(1000..9999),
      content: params[:content],
      post_id: params[:post_id]
    }
  end

  def post_params
    params.require(:post).permit(:title, :content, :category, :tags)
  end

  def reply_params
    params.require(:reply).permit(:content, :post_id)
  end
end