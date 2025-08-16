class PressController < ApplicationController
  def index
    @press_articles = [
      {
        id: 'techcrunch',
        publication: 'TechCrunch',
        title: 'Revolutionary AI Platform Changing How People Learn to Code',
        date: 'December 2025',
        excerpt: 'OneLastAI\'s phantom-powered learning platform represents a quantum leap in educational technology...',
        logo: 'TC',
        color: 'green',
        rating: 5,
        badge: 'Editor\'s Choice'
      },
      {
        id: 'wired',
        publication: 'Wired',
        title: 'The Phantom AI Teaching the Next Generation of Developers',
        date: 'November 2025',
        excerpt: 'In the shadowy realm of artificial intelligence, OneLastAI emerges as a groundbreaking force...',
        logo: 'WR',
        color: 'red',
        rating: 5,
        badge: 'Must Read'
      },
      {
        id: 'forbes',
        publication: 'Forbes',
        title: 'Best AI Learning Platform of 2025',
        date: 'October 2025',
        excerpt: 'Forbes recognizes OneLastAI as the premier AI-powered learning platform transforming education...',
        logo: 'FB',
        color: 'blue',
        rating: 5,
        badge: 'Top Pick'
      }
    ]
  end

  def show
    @publication = params[:publication]
    @article = get_article(@publication)
    
    if @article.nil?
      redirect_to press_index_path, alert: 'Article not found'
      return
    end
  end

  private

  def get_article(publication)
    case publication
    when 'techcrunch'
      {
        publication: 'TechCrunch',
        title: 'Revolutionary AI Platform Changing How People Learn to Code',
        date: 'December 15, 2025',
        author: 'Sarah Chen',
        logo: 'TC',
        color: 'green',
        excerpt: 'OneLastAI\'s phantom-powered learning platform represents a quantum leap in educational technology...',
        content: [
          {
            type: 'paragraph',
            text: 'In the rapidly evolving landscape of artificial intelligence and education technology, OneLastAI has emerged as a revolutionary force that\'s fundamentally changing how people approach learning to code.'
          },
          {
            type: 'quote',
            text: 'We\'re not just teaching code; we\'re creating a new paradigm where AI becomes your personal coding mentor, understanding your learning style and adapting in real-time.',
            author: 'OneLastAI Team'
          },
          {
            type: 'paragraph',
            text: 'The platform\'s phantom AI technology represents a breakthrough in personalized learning, offering an experience that feels almost magical in its ability to anticipate and respond to learner needs.'
          }
        ],
        tags: ['AI', 'Education', 'Technology', 'Innovation'],
        rating: 5,
        badge: 'Editor\'s Choice'
      }
    when 'wired'
      {
        publication: 'Wired',
        title: 'The Phantom AI Teaching the Next Generation of Developers',
        date: 'November 28, 2025',
        author: 'Marcus Rodriguez',
        logo: 'WR',
        color: 'red',
        excerpt: 'In the shadowy realm of artificial intelligence, OneLastAI emerges as a groundbreaking force...',
        content: [
          {
            type: 'paragraph',
            text: 'In the shadowy realm of artificial intelligence, where algorithms dance with data and machines learn to think, OneLastAI emerges as a groundbreaking force that\'s redefining the very essence of coding education.'
          },
          {
            type: 'paragraph',
            text: 'Unlike traditional coding bootcamps or online tutorials, OneLastAI\'s phantom technology creates an almost sentient learning companion that evolves with each interaction.'
          },
          {
            type: 'quote',
            text: 'It\'s like having a master programmer\'s ghost whispering the secrets of code directly into your consciousness.',
            author: 'Beta User Review'
          }
        ],
        tags: ['AI', 'Programming', 'Future Tech', 'Learning'],
        rating: 5,
        badge: 'Must Read'
      }
    when 'forbes'
      {
        publication: 'Forbes',
        title: 'Best AI Learning Platform of 2025',
        date: 'October 10, 2025',
        author: 'Jennifer Walsh',
        logo: 'FB',
        color: 'blue',
        excerpt: 'Forbes recognizes OneLastAI as the premier AI-powered learning platform transforming education...',
        content: [
          {
            type: 'paragraph',
            text: 'Forbes recognizes OneLastAI as the premier AI-powered learning platform transforming education and professional development in 2025.'
          },
          {
            type: 'paragraph',
            text: 'With its innovative phantom AI technology and comprehensive suite of learning tools, OneLastAI has established itself as the gold standard for AI-assisted education.'
          },
          {
            type: 'quote',
            text: 'OneLastAI represents the future of learning - where artificial intelligence doesn\'t replace human creativity but amplifies it exponentially.',
            author: 'Forbes Editorial Board'
          }
        ],
        tags: ['Business', 'AI', 'Education', 'Awards'],
        rating: 5,
        badge: 'Top Pick'
      }
    else
      nil
    end
  end
end