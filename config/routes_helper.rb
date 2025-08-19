# OneLastAI Routes Configuration Helper
# This module provides domain-aware routing helpers

module OneLastAI
  module RoutingHelpers
    def self.configure_routes(router)
      # Get domain configuration based on environment
      domain = Rails.env.production? ? 'onelastai.com' : 'localhost'
      
      # Configure subdomain constraints
      router.instance_eval do
        # Agent subdomain routes - only apply in production
        if Rails.env.production?
          # NeoChat subdomain
          constraints subdomain: 'neochat', domain: domain do
            root 'neochat#index', as: :neochat_subdomain_root
            post '/chat', to: 'neochat#chat'
            get '/status', to: 'neochat#status'
          end

          # EmotiSense subdomain
          constraints subdomain: 'emotisense', domain: domain do
            root 'emotisense#index', as: :emotisense_subdomain_root
            post '/process_emotion', to: 'emotisense#process_emotion'
            get '/emotion_chat', to: 'emotisense#emotion_chat'
            get '/mood_journal', to: 'emotisense#mood_journal'
            post '/mood_journal', to: 'emotisense#mood_journal'
            get '/emotion_dashboard', to: 'emotisense#emotion_dashboard'
            get '/empathy_training', to: 'emotisense#empathy_training'
            post '/process_empathy_response', to: 'emotisense#process_empathy_response'
            get '/wellness_center', to: 'emotisense#wellness_center'
            post '/analyze_voice', to: 'emotisense#analyze_voice'
            get '/export_data', to: 'emotisense#export_data'
          end

          # CineGen subdomain
          constraints subdomain: 'cinegen', domain: domain do
            root 'cinegen#index', as: :cinegen_subdomain_root
            post '/generate_video', to: 'cinegen#generate_video'
            post '/compose_scenes', to: 'cinegen#compose_scenes'
            get '/render_progress', to: 'cinegen#render_progress'
            post '/apply_emotion_sync', to: 'cinegen#apply_emotion_sync'
            get '/visual_styles', to: 'cinegen#visual_styles'
            post '/select_soundtrack', to: 'cinegen#select_soundtrack'
            get '/export_video', to: 'cinegen#export_video'
            post '/terminal_command', to: 'cinegen#terminal_command'
          end

          # ContentCrafter subdomain
          constraints subdomain: 'contentcrafter', domain: domain do
            root 'contentcrafter#index', as: :contentcrafter_subdomain_root
            post '/generate_content', to: 'contentcrafter#generate_content'
            get '/content_formats', to: 'contentcrafter#get_content_formats'
            post '/preview_content', to: 'contentcrafter#preview_content'
            post '/export_content', to: 'contentcrafter#export_content'
            post '/analyze_content', to: 'contentcrafter#analyze_content'
            post '/fusion_generate', to: 'contentcrafter#fusion_generate'
            post '/terminal_command', to: 'contentcrafter#terminal_command'
          end

          # Add more agent subdomains as needed...
        end
      end
    end
  end
end
