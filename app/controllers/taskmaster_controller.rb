# frozen_string_literal: true

class TaskmasterController < ApplicationController
  before_action :find_taskmaster_agent
  before_action :ensure_demo_user
  
  def index
    # Main agent page with hero section and terminal interface
    @agent_stats = {
      total_conversations: @agent.total_conversations,
      average_rating: @agent.average_rating.round(1),
      response_time: '< 2s',
      specializations: @agent.specializations
    }
  end
  
  def chat
    # Handle chat messages from the terminal interface
    user_message = params[:message]&.strip
    
    if user_message.blank?
      render json: { error: 'Message cannot be empty' }, status: :bad_request
      return
    end
    
    begin
      # Generate response using agent engine
      response = @agent.respond_to_user(@user, user_message, build_chat_context)
      
      render json: {
        success: true,
        response: response[:text],
        processing_time: response[:processing_time],
        agent_name: @agent.name,
        timestamp: Time.current.strftime('%H:%M:%S')
      }
    rescue StandardError => e
      Rails.logger.error "Taskmaster Error: #{e.message}"
      
      render json: {
        error: 'Sorry, I encountered an error processing your message. Please try again.',
        timestamp: Time.current.strftime('%H:%M:%S')
      }, status: :internal_server_error
    end
  end
  
  def status
    # Agent status endpoint for monitoring
    render json: {
      agent: @agent.name,
      status: @agent.status,
      uptime: time_since_last_active,
      capabilities: @agent.capabilities,
      response_style: @agent.configuration['response_style'],
      last_active: @agent.last_active_at&.strftime('%Y-%m-%d %H:%M:%S')
    }
  end
  
  private
  
  def find_taskmaster_agent
    @agent = Agent.find_by(agent_type: 'taskmaster', status: 'active')
    
    unless @agent
      redirect_to root_url(subdomain: false), alert: 'Taskmaster agent is currently unavailable'
    end
  end
  
  def ensure_demo_user
    # Create or find a demo user for the session
    session_id = session[:user_session_id] ||= SecureRandom.uuid
    
    @user = User.find_or_create_by(email: "demo_#{session_id}@taskmaster.onelastai.com") do |user|
      user.name = "Taskmaster User #{rand(1000..9999)}"
      user.preferences = {
        communication_style: 'terminal',
        interface_theme: 'dark',
        response_detail: 'comprehensive'
      }.to_json
    end
    
    session[:current_user_id] = @user.id
  end
  
  def build_chat_context
    {
      interface_mode: 'terminal',
      subdomain: 'taskmaster',
      session_id: session[:user_session_id],
      user_preferences: JSON.parse(@user.preferences || '{}'),
      conversation_history: recent_conversation_history
    }
  end
  
  def recent_conversation_history
    # Get the last 5 interactions for context
    @agent.agent_interactions
           .where(user: @user)
           .order(created_at: :desc)
           .limit(5)
           .pluck(:user_message, :agent_response)
           .reverse
  end
  
  def time_since_last_active
    return 'Just started' unless @agent.last_active_at
    
    time_diff = Time.current - @agent.last_active_at
    
    if time_diff < 1.minute
      'Just now'
    elsif time_diff < 1.hour
      "#{(time_diff / 1.minute).to_i} minutes ago"
    else
      "#{(time_diff / 1.hour).to_i} hours ago"
    end
  end
end
