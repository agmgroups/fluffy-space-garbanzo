class FeaturesController < ApplicationController
  before_action :set_page_title

  def index
    @page_title = "Features - AI Agents Platform"
    @features = [
      {
        id: 'conversational-ai',
        title: 'Conversational AI',
        description: 'Deploy sophisticated chatbots with NeoChat and EmotiSense',
        agents: ['NeoChat', 'EmotiSense', 'VocaMind'],
        icon: '💬',
        color: 'purple'
      },
      {
        id: 'content-media',
        title: 'Content & Media',
        description: 'Generate videos, craft content, and create documentation',
        agents: ['CineGen', 'ContentCrafter', 'AIBlogster'],
        icon: '🎨',
        color: 'blue'
      },
      {
        id: 'intelligence-analytics',
        title: 'Intelligence & Analytics',
        description: 'Network scanning, data analysis, and smart search capabilities',
        agents: ['NetScope', 'DataVision', 'InfoSeek'],
        icon: '🔍',
        color: 'green'
      }
    ]
  end

  def conversational_ai
    @page_title = "Conversational AI Features"
    @agents = [
      {
        name: 'NeoChat',
        path: '/neochat',
        description: 'Advanced conversational AI with context awareness',
        features: ['Context Memory', 'Multi-turn Conversations', 'Personality Adaptation']
      },
      {
        name: 'EmotiSense',
        path: '/emotisense',
        description: 'Emotion-aware AI that understands and responds to feelings',
        features: ['Emotion Detection', 'Empathetic Responses', 'Mood Tracking']
      },
      {
        name: 'VocaMind',
        path: '/vocamind',
        description: 'Voice-powered AI for natural speech interactions',
        features: ['Voice Recognition', 'Natural Speech', 'Audio Processing']
      }
    ]
  end

  def content_media
    @page_title = "Content & Media Features"
    @agents = [
      {
        name: 'CineGen',
        path: '/cinegen',
        description: 'AI-powered video generation and editing platform',
        features: ['Video Generation', 'Scene Composition', 'Emotion Sync']
      },
      {
        name: 'ContentCrafter',
        path: '/contentcrafter',
        description: 'Intelligent content creation and optimization',
        features: ['Content Generation', 'SEO Optimization', 'Multi-format Export']
      },
      {
        name: 'AIBlogster',
        path: '/aiblogster',
        description: 'AI-driven blog writing and content strategy',
        features: ['Blog Generation', 'SEO Analysis', 'Content Ideas']
      }
    ]
  end

  def intelligence_analytics
    @page_title = "Intelligence & Analytics Features"
    @agents = [
      {
        name: 'NetScope',
        path: '/netscope',
        description: 'Advanced network scanning and security analysis',
        features: ['Port Scanning', 'Vulnerability Assessment', 'Network Mapping']
      },
      {
        name: 'DataVision',
        path: '/datavision',
        description: 'Intelligent data analysis and visualization',
        features: ['Data Analysis', 'Pattern Recognition', 'Visual Reports']
      },
      {
        name: 'InfoSeek',
        path: '/infoseek',
        description: 'Smart search and information retrieval system',
        features: ['Smart Search', 'Information Extraction', 'Knowledge Mining']
      }
    ]
  end

  private

  def set_page_title
    @page_title ||= "Features"
  end
end