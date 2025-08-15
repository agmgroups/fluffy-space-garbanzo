# frozen_string_literal: true

module CinegenHelper
  # CineGen Helper Methods
  # Video utilities, scene formatting, emotion-to-visual mapping, and cinematic theme functions
  
  # Visual Style Helpers
  def visual_style_options
    Agents::CinegenEngine::VISUAL_STYLES.keys.map do |style|
      [style.humanize, style]
    end
  end
  
  def visual_style_description(style)
    style_config = Agents::CinegenEngine::VISUAL_STYLES[style]
    return "Unknown style" unless style_config
    
    "#{style_config[:mood].humanize} mood with #{style_config[:color_grade].humanize.downcase} color grading"
  end
  
  def visual_style_color(style)
    colors = {
      'noir' => '#2c2c2c',
      'cyberpunk' => '#8b5fbf',
      'vintage' => '#d4a574',
      'documentary' => '#6c7b7f',
      'fantasy' => '#9b59b6',
      'thriller' => '#e74c3c',
      'romance' => '#e91e63',
      'sci_fi' => '#3498db'
    }
    
    colors[style] || '#6c7b7f'
  end
  
  # Scene Type Helpers
  def scene_type_options
    Agents::CinegenEngine::SCENE_TYPES.map do |type|
      [type.humanize, type]
    end
  end
  
  def scene_type_icon(scene_type)
    icons = {
      'opening_sequence' => '🎬',
      'character_introduction' => '👤',
      'dialogue_scene' => '💬',
      'action_sequence' => '⚡',
      'emotional_moment' => '💫',
      'transition' => '🔄',
      'montage' => '🎭',
      'climax' => '🎯',
      'resolution' => '✨',
      'credits' => '📜'
    }
    
    icons[scene_type] || '🎥'
  end
  
  def scene_type_color(scene_type)
    colors = {
      'opening_sequence' => '#FFD700',
      'character_introduction' => '#87CEEB',
      'dialogue_scene' => '#98FB98',
      'action_sequence' => '#FF6347',
      'emotional_moment' => '#DA70D6',
      'transition' => '#F0E68C',
      'montage' => '#DDA0DD',
      'climax' => '#FF4500',
      'resolution' => '#32CD32',
      'credits' => '#C0C0C0'
    }
    
    colors[scene_type] || '#C0C0C0'
  end
  
  # Duration Formatting
  def format_duration(seconds)
    return "0s" unless seconds&.positive?
    
    if seconds < 60
      "#{seconds}s"
    elsif seconds < 3600
      minutes = seconds / 60
      remaining_seconds = seconds % 60
      remaining_seconds > 0 ? "#{minutes}m #{remaining_seconds}s" : "#{minutes}m"
    else
      hours = seconds / 3600
      remaining_minutes = (seconds % 3600) / 60
      "#{hours}h #{remaining_minutes}m"
    end
  end
  
  def duration_progress_color(current, total)
    percentage = (current.to_f / total.to_f) * 100
    
    case percentage
    when 0..25
      '#32CD32'  # Green - just started
    when 26..50
      '#FFD700'  # Gold - making progress
    when 51..75
      '#FF8C00'  # Orange - getting there
    when 76..90
      '#FF6347'  # Red-orange - almost done
    else
      '#DC143C'  # Red - complete/overrun
    end
  end
  
  # Emotion to Visual Mapping
  def emotion_to_visual_style(emotion)
    emotion_styles = {
      'joy' => 'romance',
      'sadness' => 'noir',
      'anger' => 'thriller',
      'fear' => 'thriller',
      'surprise' => 'sci_fi',
      'disgust' => 'noir',
      'trust' => 'documentary',
      'anticipation' => 'cyberpunk',
      'excitement' => 'cyberpunk',
      'love' => 'romance',
      'nostalgia' => 'vintage'
    }
    
    emotion_styles[emotion.to_s.downcase] || 'documentary'
  end
  
  def emotion_to_color_grade(emotion)
    color_grades = {
      'joy' => 'warm_golden',
      'sadness' => 'cool_blue',
      'anger' => 'high_contrast',
      'fear' => 'desaturated',
      'surprise' => 'bright_saturated',
      'disgust' => 'sickly_green',
      'trust' => 'natural',
      'anticipation' => 'electric_blue',
      'excitement' => 'vibrant',
      'love' => 'soft_pink',
      'nostalgia' => 'warm_sepia'
    }
    
    color_grades[emotion.to_s.downcase] || 'natural'
  end
  
  # Render Status Helpers
  def render_status_badge(status)
    status_config = {
      'queued' => { color: '#6c7b7f', icon: '⏳', text: 'Queued' },
      'rendering' => { color: '#f39c12', icon: '🎬', text: 'Rendering' },
      'completed' => { color: '#27ae60', icon: '✅', text: 'Complete' },
      'failed' => { color: '#e74c3c', icon: '❌', text: 'Failed' },
      'paused' => { color: '#f39c12', icon: '⏸️', text: 'Paused' }
    }
    
    config = status_config[status.to_s] || status_config['queued']
    
    content_tag :span, class: 'render-status-badge', 
                style: "background-color: #{config[:color]}; color: white; padding: 0.25rem 0.5rem; border-radius: 12px; font-size: 0.8rem;" do
      "#{config[:icon]} #{config[:text]}"
    end
  end
  
  def render_progress_bar(progress, options = {})
    progress = [0, [100, progress.to_i].min].max
    color = options[:color] || duration_progress_color(progress, 100)
    height = options[:height] || '20px'
    
    content_tag :div, class: 'render-progress', style: "height: #{height};" do
      content_tag :div, '', class: 'render-progress-bar',
                  style: "width: #{progress}%; background: linear-gradient(90deg, #{color}, #{lighten_color(color)});",
                  data: { progress: progress }
    end
  end
  
  # File Size Formatting
  def format_file_size(bytes)
    return "0 B" unless bytes&.positive?
    
    units = %w[B KB MB GB TB]
    size = bytes.to_f
    unit_index = 0
    
    while size >= 1024 && unit_index < units.length - 1
      size /= 1024
      unit_index += 1
    end
    
    formatted_size = unit_index == 0 ? size.to_i : format('%.1f', size)
    "#{formatted_size} #{units[unit_index]}"
  end
  
  # Project Status Helpers
  def project_card(project)
    content_tag :div, class: 'cinema-card project-card', 
                style: "border-left: 4px solid #{visual_style_color(project[:style] || 'documentary')};" do
      concat content_tag(:h3, project[:title], class: 'project-title')
      concat content_tag(:div, class: 'project-meta') do
        concat content_tag(:span, "#{scene_type_icon('opening_sequence')} #{project[:scenes] || 'N/A'} scenes", class: 'meta-item')
        concat content_tag(:span, "🎨 #{(project[:style] || 'documentary').humanize}", class: 'meta-item')
        concat content_tag(:span, "⏱️ #{format_duration(project[:duration])}", class: 'meta-item')
        concat render_status_badge(project[:status] || 'unknown')
      end
      if project[:created_at]
        concat content_tag(:div, "Created #{time_ago_in_words(project[:created_at])} ago", 
                          class: 'project-timestamp')
      end
    end
  end
  
  # Scene Timeline Helper
  def scene_timeline(scenes)
    return content_tag(:p, "No scenes available", class: 'text-muted') if scenes.blank?
    
    content_tag :div, class: 'scene-timeline' do
      scenes.each_with_index do |scene, index|
        concat content_tag(:div, class: 'scene-item', 
                          style: "border-left-color: #{scene_type_color(scene[:type] || scene['type'])}") do
          concat content_tag(:div, class: 'scene-header') do
            concat content_tag(:h4, "#{scene_type_icon(scene[:type] || scene['type'])} Scene #{index + 1}: #{(scene[:type] || scene['type']).humanize}")
            concat content_tag(:span, format_duration(scene[:duration] || scene['duration']), class: 'scene-duration')
          end
          concat content_tag(:p, scene[:description] || scene['description'], class: 'scene-description')
          if scene[:visual_elements] || scene['visual_elements']
            elements = scene[:visual_elements] || scene['visual_elements']
            concat content_tag(:div, class: 'scene-elements') do
              concat content_tag(:strong, "Visual Elements: ")
              concat elements.join(', ')
            end
          end
        end
      end
    end
  end
  
  # Soundtrack Helper
  def soundtrack_info(soundtrack)
    return content_tag(:p, "No soundtrack selected", class: 'text-muted') unless soundtrack
    
    content_tag :div, class: 'soundtrack-info' do
      concat content_tag(:h4, "🎵 Soundtrack: #{soundtrack[:type]&.humanize || soundtrack['type']&.humanize}")
      if soundtrack[:tracks] || soundtrack['tracks']
        tracks = soundtrack[:tracks] || soundtrack['tracks']
        concat content_tag(:ul, class: 'track-list') do
          tracks.each do |track|
            concat content_tag(:li, "Track #{track[:scene] || track['scene']}: #{track[:track] || track['track']}")
          end
        end
      end
    end
  end
  
  # Terminal Command Helper
  def terminal_command_box(command, description = nil)
    content_tag :div, class: 'terminal-command' do
      concat content_tag(:div, description, class: 'command-description') if description
      concat content_tag(:pre, command, class: 'command-code')
      concat content_tag(:button, "Copy", class: 'copy-button', onclick: "copyToClipboard('#{escape_javascript(command)}')")
    end
  end
  
  # Analytics Helpers
  def analytics_chart_data(data, type = 'bar')
    {
      type: type,
      data: data,
      options: {
        responsive: true,
        plugins: {
          legend: {
            labels: {
              color: '#C0C0C0'
            }
          }
        },
        scales: type == 'bar' ? {
          y: {
            ticks: { color: '#C0C0C0' },
            grid: { color: 'rgba(192, 192, 192, 0.1)' }
          },
          x: {
            ticks: { color: '#C0C0C0' },
            grid: { color: 'rgba(192, 192, 192, 0.1)' }
          }
        } : {}
      }
    }.to_json.html_safe
  end
  
  def style_usage_chart(style_breakdown)
    data = {
      labels: style_breakdown.keys,
      datasets: [{
        label: 'Videos Generated',
        data: style_breakdown.values,
        backgroundColor: style_breakdown.keys.map { |style| visual_style_color(style.downcase) },
        borderColor: '#FFD700',
        borderWidth: 1
      }]
    }
    
    analytics_chart_data(data)
  end
  
  # Quality Badges
  def quality_badge(quality)
    quality_colors = {
      '4K UHD' => '#e74c3c',
      '1080p HD' => '#f39c12',
      '720p HD' => '#27ae60',
      '480p' => '#95a5a6'
    }
    
    color = quality_colors[quality] || '#95a5a6'
    
    content_tag :span, quality, class: 'quality-badge',
                style: "background: #{color}; color: white; padding: 0.2rem 0.5rem; border-radius: 8px; font-size: 0.7rem; font-weight: bold;"
  end
  
  # Time Formatting
  def format_timestamp(timestamp)
    return "Unknown" unless timestamp
    
    if timestamp.is_a?(String)
      timestamp
    elsif timestamp.respond_to?(:strftime)
      if timestamp > 1.day.ago
        time_ago_in_words(timestamp) + " ago"
      else
        timestamp.strftime("%b %d, %Y at %I:%M %p")
      end
    else
      timestamp.to_s
    end
  end
  
  # Emotion Sync Status
  def emotion_sync_status
    if defined?(Agents::EmotisenseEngine) && Agent.exists?(agent_type: 'emotisense')
      content_tag :span, "🎭 EmotiSense Connected", class: 'sync-status connected',
                  style: "color: #27ae60; font-weight: bold;"
    else
      content_tag :span, "🎭 EmotiSense Unavailable", class: 'sync-status disconnected',
                  style: "color: #e74c3c; font-weight: bold;"
    end
  end
  
  private
  
  # Helper to lighten colors for gradients
  def lighten_color(color, amount = 0.2)
    # Simple color lightening - in production, use a proper color manipulation gem
    if color.start_with?('#')
      color + '80'  # Add some transparency as a simple lightening effect
    else
      color
    end
  end
end
