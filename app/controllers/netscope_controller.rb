# frozen_string_literal: true

class NetscopeController < ApplicationController
  before_action :set_agent
  before_action :set_network_context
  
  def index
    # Main NetScope terminal interface
    
    # Agent stats for the interface
    @agent_stats = {
      total_conversations: @agent.total_conversations,
      average_rating: @agent.average_rating.round(1),
      response_time: '< 2s',
      specializations: @agent.specializations
    }
  end
  
  def scan_target
    begin
      target = params[:target] || params[:message]
      scan_type = params[:scan_type] || 'auto'
      
      if target.blank?
        render json: { 
          success: false, 
          message: "Please provide a target IP address or domain to scan" 
        }
        return
      end
      
      # Validate target format
      unless valid_target?(target)
        render json: { 
          success: false, 
          message: "Invalid target format. Please provide a valid IP address or domain name." 
        }
        return
      end
      
      # Process network scan request
      response = @netscope_engine.process_input(
        current_user, 
        build_scan_command(target, scan_type),
        network_context_params
      )
      
      # Update session stats
      increment_session_stats('scans_performed')
      update_scan_history(target, scan_type)
      
      render json: {
        success: true,
        scan_response: response[:text],
        metadata: response[:metadata],
        scan_data: response[:scan_data],
        timestamp: response[:timestamp],
        processing_time: response[:processing_time]
      }
      
    rescue => e
      Rails.logger.error "NetScope scan error: #{e.message}"
      render json: { 
        success: false, 
        message: "Network scan encountered an issue. Please verify the target and try again." 
      }
    end
  end
  
  def port_scan
    begin
      target = params[:target]
      port_range = params[:port_range] || 'common'
      scan_options = params[:scan_options] || {}
      
      if target.blank?
        render json: { 
          success: false, 
          message: "Please specify a target for port scanning" 
        }
        return
      end
      
      scan_command = "ports #{target} #{port_range}"
      response = @netscope_engine.process_input(
        current_user,
        scan_command,
        network_context_params.merge(scan_options: scan_options)
      )
      
      increment_session_stats('port_scans')
      
      render json: {
        success: true,
        port_scan_results: response[:scan_data],
        scan_summary: response[:text],
        target: target,
        ports_scanned: response[:metadata][:ports_scanned] || 0
      }
      
    rescue => e
      Rails.logger.error "NetScope port scan error: #{e.message}"
      render json: { 
        success: false, 
        message: "Port scan failed. Please check the target and try again." 
      }
    end
  end
  
  def whois_lookup
    begin
      domain = params[:domain] || params[:target]
      
      if domain.blank?
        render json: { 
          success: false, 
          message: "Please provide a domain name for WHOIS lookup" 
        }
        return
      end
      
      # Clean domain input
      domain = clean_domain(domain)
      
      response = @netscope_engine.perform_whois_lookup(domain, network_context_params)
      
      increment_session_stats('whois_lookups')
      
      render json: {
        success: true,
        whois_data: response[:results],
        domain: domain,
        registrar: response[:metadata][:registrar],
        expiry_info: {
          expiry_date: response[:metadata][:expiry_date],
          days_until_expiry: response[:metadata][:days_until_expiry]
        }
      }
      
    rescue => e
      Rails.logger.error "NetScope WHOIS error: #{e.message}"
      render json: { 
        success: false, 
        message: "WHOIS lookup failed. Please verify the domain name." 
      }
    end
  end
  
  def dns_lookup
    begin
      target = params[:target]
      record_types = params[:record_types] || ['A', 'MX', 'TXT']
      
      if target.blank?
        render json: { 
          success: false, 
          message: "Please specify a domain for DNS lookup" 
        }
        return
      end
      
      # Ensure record_types is an array
      record_types = [record_types] unless record_types.is_a?(Array)
      
      response = @netscope_engine.resolve_dns_records(
        target, 
        record_types, 
        network_context_params
      )
      
      increment_session_stats('dns_lookups')
      
      render json: {
        success: true,
        dns_records: response[:results][:records],
        target: target,
        record_types_queried: record_types,
        total_records: response[:metadata][:total_records],
        health_status: response[:results][:health_check]
      }
      
    rescue => e
      Rails.logger.error "NetScope DNS error: #{e.message}"
      render json: { 
        success: false, 
        message: "DNS lookup encountered an issue. Please check the domain." 
      }
    end
  end
  
  def threat_check
    begin
      target = params[:target]
      
      if target.blank?
        render json: { 
          success: false, 
          message: "Please provide an IP or domain for threat intelligence check" 
        }
        return
      end
      
      response = @netscope_engine.check_threat_intelligence(target, network_context_params)
      
      increment_session_stats('threat_checks')
      
      render json: {
        success: true,
        threat_analysis: response[:results],
        target: target,
        risk_level: response[:metadata][:overall_risk],
        confidence: response[:metadata][:confidence],
        sources_checked: response[:metadata][:sources_checked]
      }
      
    rescue => e
      Rails.logger.error "NetScope threat check error: #{e.message}"
      render json: { 
        success: false, 
        message: "Threat intelligence check failed. Please try again." 
      }
    end
  end
  
  def ssl_analysis
    begin
      target = params[:target]
      
      if target.blank?
        render json: { 
          success: false, 
          message: "Please specify a domain for SSL analysis" 
        }
        return
      end
      
      response = @netscope_engine.analyze_ssl_certificate(target, network_context_params)
      
      increment_session_stats('ssl_analyses')
      
      render json: {
        success: true,
        ssl_data: response[:results],
        target: target,
        certificate_valid: response[:metadata][:certificate_valid],
        security_grade: response[:metadata][:security_grade],
        expires_in_days: response[:metadata][:expires_in_days]
      }
      
    rescue => e
      Rails.logger.error "NetScope SSL analysis error: #{e.message}"
      render json: { 
        success: false, 
        message: "SSL analysis failed. Ensure the target supports HTTPS." 
      }
    end
  end
  
  def comprehensive_scan
    begin
      target = params[:target]
      
      if target.blank?
        render json: { 
          success: false, 
          message: "Please provide a target for comprehensive scanning" 
        }
        return
      end
      
      response = @netscope_engine.perform_comprehensive_scan(target, network_context_params)
      
      increment_session_stats('comprehensive_scans')
      
      render json: {
        success: true,
        comprehensive_results: response[:results],
        comprehensive_report: response[:report],
        target: target,
        modules_executed: response[:metadata][:modules_executed],
        overall_risk: response[:metadata][:overall_risk],
        recommendations: response[:metadata][:recommendations]
      }
      
    rescue => e
      Rails.logger.error "NetScope comprehensive scan error: #{e.message}"
      render json: { 
        success: false, 
        message: "Comprehensive scan encountered an issue. Please try again." 
      }
    end
  end
  
  def get_scan_history
    begin
      history = session[:netscope_scan_history] || []
      stats = @netscope_engine.get_network_stats
      
      render json: {
        success: true,
        scan_history: history.last(20),
        session_stats: @session_data,
        network_stats: stats
      }
      
    rescue => e
      Rails.logger.error "NetScope history error: #{e.message}"
      render json: { 
        success: false, 
        message: "Unable to retrieve scan history." 
      }
    end
  end
  
  def export_results
    begin
      export_format = params[:format] || 'json'
      scan_results = params[:scan_results] || session[:netscope_last_scan]
      
      if scan_results.blank?
        render json: { 
          success: false, 
          message: "No scan results available for export" 
        }
        return
      end
      
      exported_data = format_export_data(scan_results, export_format)
      
      render json: {
        success: true,
        exported_data: exported_data,
        format: export_format,
        filename: "netscope_scan_#{Time.current.strftime('%Y%m%d_%H%M%S')}.#{export_format}"
      }
      
    rescue => e
      Rails.logger.error "NetScope export error: #{e.message}"
      render json: { 
        success: false, 
        message: "Export process failed." 
      }
    end
  end
  
  def get_network_tools
    render json: {
      scan_types: Agents::NetscopeEngine::SCAN_TYPES,
      common_ports: Agents::NetscopeEngine::COMMON_PORTS,
      dns_record_types: Agents::NetscopeEngine::DNS_RECORD_TYPES,
      threat_categories: Agents::NetscopeEngine::THREAT_CATEGORIES
    }
  end
  
  def terminal_command
    command = params[:command]
    args = params[:args] || []
    
    case command
    when 'stats'
      stats = @netscope_engine.get_network_stats
      render json: { success: true, stats: stats }
    when 'tools'
      render json: { 
        success: true, 
        tools: Agents::NetscopeEngine::SCAN_TYPES 
      }
    when 'scan'
      if args.any?
        target = args.first
        response = @netscope_engine.get_ip_intelligence(target, {})
        render json: { success: true, scan_result: response }
      else
        render json: { success: false, message: "Please specify a target to scan" }
      end
    when 'ports'
      if args.any?
        target = args.first
        response = @netscope_engine.scan_ports(target, :common, {})
        render json: { success: true, port_results: response }
      else
        render json: { success: false, message: "Please specify a target for port scan" }
      end
    when 'whois'
      if args.any?
        domain = args.first
        response = @netscope_engine.perform_whois_lookup(domain, {})
        render json: { success: true, whois_result: response }
      else
        render json: { success: false, message: "Please specify a domain for WHOIS lookup" }
      end
    when 'help'
      help_text = generate_netscope_help_text
      render json: { success: true, help: help_text }
    else
      render json: { 
        success: false, 
        message: "Unknown command: #{command}. Type 'help' for available commands." 
      }
    end
  end
  
  private
  
  def set_agent
    @agent = Agent.find_by(agent_type: 'netscope') || create_default_agent
    @netscope_engine = @agent.engine_class.new(@agent)
  end
  
  def set_network_context
    @network_stats = @netscope_engine.get_network_stats
    @session_data = {
      scans_performed: session[:netscope_scans] || 0,
      port_scans: session[:netscope_ports] || 0,
      whois_lookups: session[:netscope_whois] || 0,
      dns_lookups: session[:netscope_dns] || 0,
      threat_checks: session[:netscope_threats] || 0,
      ssl_analyses: session[:netscope_ssl] || 0,
      comprehensive_scans: session[:netscope_comprehensive] || 0,
      session_start: session[:netscope_start] || Time.current,
      last_target: session[:netscope_last_target] || 'None'
    }
  end
  
  def network_context_params
    {
      scan_type: params[:scan_type],
      fast_scan: params[:fast_scan] == 'true',
      stealth_mode: params[:stealth_mode] == 'true',
      sync_memory: params[:sync_memory] == 'true',
      agent: 'netscope',
      user_agent: request.user_agent,
      source_ip: request.remote_ip
    }
  end
  
  def increment_session_stats(stat_key)
    session["netscope_#{stat_key}"] = (session["netscope_#{stat_key}"] || 0) + 1
    session[:netscope_start] ||= Time.current
  end
  
  def update_scan_history(target, scan_type)
    history = session[:netscope_scan_history] || []
    history << {
      target: target,
      scan_type: scan_type,
      timestamp: Time.current.strftime('%H:%M:%S'),
      date: Date.current.strftime('%Y-%m-%d')
    }
    session[:netscope_scan_history] = history.last(50)
    session[:netscope_last_target] = target
  end
  
  def valid_target?(target)
    # Validate IP address
    return true if target.match?(/\A(?:[0-9]{1,3}\.){3}[0-9]{1,3}\z/)
    
    # Validate domain name
    return true if target.match?(/\A[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]?(?:\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]?)*\z/)
    
    false
  end
  
  def clean_domain(domain)
    # Remove http/https prefix if present
    domain = domain.gsub(/^https?:\/\//, '')
    
    # Remove trailing slash
    domain = domain.gsub(/\/$/, '')
    
    # Remove www prefix if present
    domain = domain.gsub(/^www\./, '')
    
    domain
  end
  
  def build_scan_command(target, scan_type)
    case scan_type
    when 'port_scan', 'ports'
      "ports #{target}"
    when 'whois'
      "whois #{target}"
    when 'dns'
      "dns #{target}"
    when 'threat'
      "threat #{target}"
    when 'ssl'
      "ssl #{target}"
    when 'comprehensive', 'full'
      "comprehensive #{target}"
    else
      "scan #{target}"
    end
  end
  
  def format_export_data(scan_results, format)
    case format.downcase
    when 'json'
      scan_results.to_json
    when 'csv'
      convert_to_csv(scan_results)
    when 'xml'
      convert_to_xml(scan_results)
    when 'txt'
      convert_to_text(scan_results)
    else
      scan_results.to_json
    end
  end
  
  def convert_to_csv(data)
    "Target,Scan Type,Timestamp,Results\n#{data[:target]},#{data[:scan_type]},#{data[:timestamp]},\"#{data[:results].to_s.gsub('"', '""')}\""
  end
  
  def convert_to_xml(data)
    "<?xml version=\"1.0\"?>\n<scan>\n  <target>#{data[:target]}</target>\n  <type>#{data[:scan_type]}</type>\n  <timestamp>#{data[:timestamp]}</timestamp>\n</scan>"
  end
  
  def convert_to_text(data)
    "NetScope Scan Results\n" +
    "Target: #{data[:target]}\n" +
    "Scan Type: #{data[:scan_type]}\n" +
    "Timestamp: #{data[:timestamp]}\n" +
    "Results: #{data[:results]}"
  end
  
  def create_default_agent
    Agent.create!(
      name: 'NetScope',
      agent_type: 'netscope',
      personality_traits: [
        'analytical', 'thorough', 'security_focused', 'efficient', 
        'precise', 'investigative', 'systematic', 'reliable'
      ],
      capabilities: [
        'ip_intelligence', 'port_scanning', 'whois_lookup', 'dns_resolution',
        'threat_intelligence', 'ssl_analysis', 'network_tracing', 'subdomain_enumeration'
      ],
      specializations: [
        'network_reconnaissance', 'security_assessment', 'domain_analysis',
        'infrastructure_mapping', 'threat_hunting', 'vulnerability_detection',
        'certificate_analysis', 'network_monitoring'
      ],
      configuration: {
        'emoji' => '🌐',
        'tagline' => 'Your Network Intelligence Agent - Deep Reconnaissance & Security Insights',
        'primary_color' => '#00FF41',
        'secondary_color' => '#008F11',
        'response_style' => 'technical_precise'
      },
      status: 'active'
    )
  end
  
  def generate_netscope_help_text
    {
      commands: {
        'stats' => 'Show network scanning statistics and capabilities',
        'tools' => 'List all available scanning tools and methods',
        'scan [target]' => 'Perform basic IP intelligence scan',
        'ports [target]' => 'Execute port scan on target',
        'whois [domain]' => 'Perform WHOIS domain lookup',
        'help' => 'Show this help message'
      },
      scan_types: Agents::NetscopeEngine::SCAN_TYPES.keys.map(&:to_s),
      examples: [
        "scan 8.8.8.8 - Basic IP intelligence",
        "ports example.com - Port scan website",
        "whois google.com - Domain registration info",
        "dns example.com - DNS record resolution",
        "threat 1.2.3.4 - Threat intelligence check",
        "ssl example.com - SSL certificate analysis",
        "comprehensive example.com - Full security scan"
      ],
      advanced_features: [
        "🌐 Multi-source IP intelligence with geolocation",
        "🔍 Advanced port scanning (TCP/UDP)",
        "📋 Complete WHOIS analysis with expiry tracking",
        "🧬 DNS health checking and configuration analysis",
        "🛡️ Multi-source threat intelligence feeds",
        "🔐 SSL/TLS certificate security assessment",
        "🛣️ Network path tracing and topology mapping",
        "💾 Export results in multiple formats (JSON, CSV, XML)"
      ],
      security_note: "All scans are performed ethically for legitimate reconnaissance and security assessment purposes."
    }
  end
end
