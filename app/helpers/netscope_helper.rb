# frozen_string_literal: true

module NetscopeHelper
  # Terminal styling and network visualization helpers for NetScope
  
  def netscope_terminal_prompt
    "netscope@reconnaissance:~$ "
  end
  
  def netscope_welcome_ascii
    <<~ASCII
      ███╗   ██╗███████╗████████╗███████╗ ██████╗ ██████╗ ██████╗ ███████╗
      ████╗  ██║██╔════╝╚══██╔══╝██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝
      ██╔██╗ ██║█████╗     ██║   ███████╗██║     ██║   ██║██████╔╝█████╗  
      ██║╚██╗██║██╔══╝     ██║   ╚════██║██║     ██║   ██║██╔═══╝ ██╔══╝  
      ██║ ╚████║███████╗   ██║   ███████║╚██████╗╚██████╔╝██║     ███████╗
      ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚══════╝
      
      🌐 Network & IP Insights - Advanced Reconnaissance Platform 🔍
      ═══════════════════════════════════════════════════════════════════
    ASCII
  end
  
  def netscope_stats_display(stats)
    <<~STATS
      ┌─ Network Statistics ──────────────────────────────────────────────┐
      │ Total Scans: #{stats[:total_scans].to_s.ljust(8)} │ Active Scans: #{stats[:active_scans].to_s.ljust(8)}  │
      │ IPs Analyzed: #{stats[:ips_analyzed].to_s.ljust(7)} │ Domains Checked: #{stats[:domains_checked].to_s.ljust(6)} │
      │ Threats Found: #{stats[:threats_found].to_s.ljust(6)} │ Open Ports: #{stats[:open_ports].to_s.ljust(9)}   │
      │ SSL Certs: #{stats[:ssl_analyzed].to_s.ljust(8)} │ DNS Records: #{stats[:dns_records].to_s.ljust(8)}  │
      └───────────────────────────────────────────────────────────────────┘
    STATS
  end
  
  def netscope_session_stats(session_data)
    <<~SESSION
      ┌─ Session Statistics ──────────────────────────────────────────────┐
      │ Scans Performed: #{session_data[:scans_performed].to_s.ljust(8)} │ Port Scans: #{session_data[:port_scans].to_s.ljust(12)}    │
      │ WHOIS Lookups: #{session_data[:whois_lookups].to_s.ljust(10)} │ DNS Lookups: #{session_data[:dns_lookups].to_s.ljust(11)}   │
      │ Threat Checks: #{session_data[:threat_checks].to_s.ljust(10)} │ SSL Analyses: #{session_data[:ssl_analyses].to_s.ljust(10)}  │
      │ Session Start: #{format_session_time(session_data[:session_start]).ljust(19)}          │
      │ Last Target: #{truncate_target(session_data[:last_target]).ljust(21)}            │
      └───────────────────────────────────────────────────────────────────┘
    SESSION
  end
  
  def netscope_scan_types_grid
    scan_types = [
      ['🔍 IP Intelligence', 'Comprehensive IP analysis and geolocation'],
      ['🚪 Port Scanning', 'TCP/UDP port discovery and service detection'],
      ['📋 WHOIS Lookup', 'Domain registration and ownership information'],
      ['🧬 DNS Resolution', 'Complete DNS record analysis and health check'],
      ['🛡️ Threat Intel', 'Multi-source threat intelligence and reputation'],
      ['🔐 SSL Analysis', 'Certificate security assessment and validation'],
      ['🛣️ Traceroute', 'Network path tracing and topology mapping'],
      ['🌐 Subdomain Enum', 'Subdomain discovery and enumeration'],
      ['📊 Comprehensive', 'Full-spectrum security and reconnaissance scan'],
      ['🔄 Reverse DNS', 'PTR record resolution and hostname mapping']
    ]
    
    output = "┌─ Available Scan Types ────────────────────────────────────────────┐\n"
    scan_types.each do |name, description|
      output += "│ #{name.ljust(15)} │ #{description.ljust(45)} │\n"
    end
    output += "└───────────────────────────────────────────────────────────────────┘"
    output
  end
  
  def netscope_command_help
    commands = [
      ['scan [target]', 'Perform IP intelligence scan'],
      ['ports [target]', 'Execute port scan on target'],
      ['whois [domain]', 'Domain WHOIS lookup'],
      ['dns [target]', 'DNS record resolution'],
      ['threat [target]', 'Threat intelligence check'],
      ['ssl [domain]', 'SSL certificate analysis'],
      ['trace [target]', 'Network traceroute'],
      ['subs [domain]', 'Subdomain enumeration'],
      ['comp [target]', 'Comprehensive scan'],
      ['stats', 'Show network statistics'],
      ['history', 'View scan history'],
      ['export', 'Export scan results'],
      ['tools', 'List available tools'],
      ['help', 'Show this help menu']
    ]
    
    output = "┌─ NetScope Commands ───────────────────────────────────────────────┐\n"
    commands.each do |command, description|
      output += "│ #{command.ljust(18)} │ #{description.ljust(43)} │\n"
    end
    output += "└───────────────────────────────────────────────────────────────────┘"
    output
  end
  
  def format_ip_intelligence(data)
    return "No IP intelligence data available" unless data.is_a?(Hash)
    
    <<~IP_INTEL
      ┌─ IP Intelligence Report ──────────────────────────────────────────┐
      │ IP Address: #{data[:ip]&.ljust(18)} │ Status: #{data[:status]&.ljust(15)}    │
      │ Country: #{data[:country]&.ljust(21)} │ Region: #{data[:region]&.ljust(15)}    │
      │ City: #{data[:city]&.ljust(24)} │ ISP: #{data[:isp]&.ljust(18)}       │
      │ Organization: #{data[:org]&.ljust(16)} │ ASN: #{data[:asn]&.ljust(18)}       │
      │ Threat Level: #{data[:threat_level]&.ljust(16)} │ Last Seen: #{data[:last_seen]&.ljust(12)} │
      └───────────────────────────────────────────────────────────────────┘
    IP_INTEL
  end
  
  def format_port_scan_results(data)
    return "No port scan data available" unless data.is_a?(Hash)
    
    output = "┌─ Port Scan Results ───────────────────────────────────────────────┐\n"
    output += "│ Target: #{data[:target]&.ljust(20)} │ Ports Scanned: #{data[:total_ports]&.to_s&.ljust(13)} │\n"
    output += "│ Open Ports: #{data[:open_ports]&.count&.to_s&.ljust(16)} │ Scan Duration: #{data[:scan_time]&.ljust(13)} │\n"
    output += "├───────────────────────────────────────────────────────────────────┤\n"
    
    if data[:open_ports]&.any?
      data[:open_ports].each do |port_info|
        port = port_info[:port] || port_info['port']
        service = port_info[:service] || port_info['service'] || 'Unknown'
        state = port_info[:state] || port_info['state'] || 'Open'
        output += "│ Port #{port.to_s.ljust(6)} │ #{service.ljust(20)} │ #{state.ljust(17)} │\n"
      end
    else
      output += "│ No open ports found or scan data unavailable                     │\n"
    end
    
    output += "└───────────────────────────────────────────────────────────────────┘"
    output
  end
  
  def format_whois_data(data)
    return "No WHOIS data available" unless data.is_a?(Hash)
    
    <<~WHOIS
      ┌─ WHOIS Information ───────────────────────────────────────────────┐
      │ Domain: #{data[:domain]&.ljust(22)} │ Status: #{data[:status]&.ljust(15)}    │
      │ Registrar: #{data[:registrar]&.ljust(19)} │ Created: #{data[:created]&.ljust(14)}   │
      │ Updated: #{data[:updated]&.ljust(21)} │ Expires: #{data[:expires]&.ljust(14)}   │
      │ Nameservers: #{data[:nameservers]&.to_s&.ljust(53)}                │
      │ Registrant: #{data[:registrant]&.ljust(54)}                 │
      └───────────────────────────────────────────────────────────────────┘
    WHOIS
  end
  
  def format_dns_records(data)
    return "No DNS data available" unless data.is_a?(Hash)
    
    output = "┌─ DNS Records ─────────────────────────────────────────────────────┐\n"
    output += "│ Domain: #{data[:domain]&.ljust(58)}                │\n"
    output += "├───────────────────────────────────────────────────────────────────┤\n"
    
    if data[:records]&.any?
      data[:records].each do |record|
        type = record[:type] || record['type'] || 'Unknown'
        value = record[:value] || record['value'] || 'N/A'
        ttl = record[:ttl] || record['ttl'] || 'N/A'
        output += "│ #{type.ljust(6)} │ #{value.ljust(35)} │ TTL: #{ttl.to_s.ljust(10)} │\n"
      end
    else
      output += "│ No DNS records found or data unavailable                         │\n"
    end
    
    output += "└───────────────────────────────────────────────────────────────────┘"
    output
  end
  
  def format_threat_intelligence(data)
    return "No threat intelligence data available" unless data.is_a?(Hash)
    
    risk_color = case data[:risk_level]&.downcase
                 when 'high', 'critical'
                   '🔴'
                 when 'medium'
                   '🟡'
                 when 'low'
                   '🟢'
                 else
                   '⚪'
                 end
    
    <<~THREAT
      ┌─ Threat Intelligence Report ──────────────────────────────────────┐
      │ Target: #{data[:target]&.ljust(22)} │ Risk Level: #{risk_color} #{data[:risk_level]&.ljust(12)} │
      │ Confidence: #{data[:confidence]&.to_s&.ljust(18)} │ Sources: #{data[:sources]&.count&.to_s&.ljust(15)}    │
      │ Categories: #{data[:categories]&.join(', ')&.ljust(53)}             │
      │ Last Seen: #{data[:last_seen]&.ljust(21)} │ First Seen: #{data[:first_seen]&.ljust(12)} │
      │ Reputation: #{data[:reputation]&.ljust(53)}              │
      └───────────────────────────────────────────────────────────────────┘
    THREAT
  end
  
  def format_ssl_analysis(data)
    return "No SSL analysis data available" unless data.is_a?(Hash)
    
    grade_color = case data[:grade]&.upcase
                  when 'A+', 'A'
                    '🟢'
                  when 'B'
                    '🟡'
                  when 'C', 'D', 'F'
                    '🔴'
                  else
                    '⚪'
                  end
    
    <<~SSL
      ┌─ SSL Certificate Analysis ────────────────────────────────────────┐
      │ Domain: #{data[:domain]&.ljust(22)} │ Grade: #{grade_color} #{data[:grade]&.ljust(13)}      │
      │ Valid: #{data[:valid]&.to_s&.ljust(23)} │ Expires: #{data[:expires_in]&.ljust(13)}   │
      │ Issuer: #{data[:issuer]&.ljust(58)}                │
      │ Subject: #{data[:subject]&.ljust(57)}               │
      │ Key Size: #{data[:key_size]&.to_s&.ljust(20)} │ Protocol: #{data[:protocol]&.ljust(13)}  │
      │ Cipher: #{data[:cipher]&.ljust(58)}                │
      └───────────────────────────────────────────────────────────────────┘
    SSL
  end
  
  def format_scan_history(history)
    return "No scan history available" unless history&.any?
    
    output = "┌─ Recent Scan History ─────────────────────────────────────────────┐\n"
    output += "│ Time     │ Target              │ Type          │ Status       │\n"
    output += "├──────────┼─────────────────────┼───────────────┼──────────────┤\n"
    
    history.last(10).each do |scan|
      time = scan[:timestamp] || scan['timestamp'] || 'Unknown'
      target = truncate_target(scan[:target] || scan['target'] || 'Unknown')
      type = scan[:scan_type] || scan['scan_type'] || 'Unknown'
      status = scan[:status] || scan['status'] || 'Completed'
      
      output += "│ #{time.ljust(8)} │ #{target.ljust(19)} │ #{type.ljust(13)} │ #{status.ljust(12)} │\n"
    end
    
    output += "└───────────────────────────────────────────────────────────────────┘"
    output
  end
  
  def format_network_topology(data)
    return "Network topology data unavailable" unless data.is_a?(Hash) && data[:hops]
    
    output = "┌─ Network Traceroute Path ─────────────────────────────────────────┐\n"
    output += "│ Hop │ IP Address        │ Hostname              │ RTT (ms)    │\n"
    output += "├─────┼───────────────────┼───────────────────────┼─────────────┤\n"
    
    data[:hops].each_with_index do |hop, index|
      hop_num = (index + 1).to_s.ljust(3)
      ip = hop[:ip] || hop['ip'] || '*'
      hostname = hop[:hostname] || hop['hostname'] || 'Unknown'
      rtt = hop[:rtt] || hop['rtt'] || 'N/A'
      
      output += "│ #{hop_num} │ #{ip.ljust(17)} │ #{hostname.ljust(21)} │ #{rtt.to_s.ljust(11)} │\n"
    end
    
    output += "└───────────────────────────────────────────────────────────────────┘"
    output
  end
  
  def netscope_status_indicators
    {
      online: '🟢 ONLINE',
      scanning: '🔍 SCANNING',
      analyzing: '🧠 ANALYZING',
      complete: '✅ COMPLETE',
      error: '🔴 ERROR',
      warning: '🟡 WARNING',
      secure: '🔒 SECURE',
      threat: '⚠️ THREAT',
      unknown: '❓ UNKNOWN'
    }
  end
  
  def scan_progress_bar(percentage)
    bar_length = 50
    filled_length = (percentage / 100.0 * bar_length).to_i
    bar = '█' * filled_length + '░' * (bar_length - filled_length)
    "#{bar} #{percentage.round(1)}%"
  end
  
  def risk_level_badge(level)
    case level&.downcase
    when 'critical'
      '🔴 CRITICAL'
    when 'high'
      '🟠 HIGH'
    when 'medium'
      '🟡 MEDIUM'
    when 'low'
      '🟢 LOW'
    when 'minimal'
      '⚪ MINIMAL'
    else
      '❓ UNKNOWN'
    end
  end
  
  def format_comprehensive_report(data)
    return "No comprehensive scan data available" unless data.is_a?(Hash)
    
    output = "┌─ Comprehensive Scan Report ───────────────────────────────────────┐\n"
    output += "│ Target: #{data[:target]&.ljust(58)}                │\n"
    output += "│ Scan Duration: #{data[:scan_duration]&.ljust(21)} │ Risk: #{risk_level_badge(data[:overall_risk])} │\n"
    output += "├───────────────────────────────────────────────────────────────────┤\n"
    
    if data[:modules]&.any?
      data[:modules].each do |module_name, module_data|
        status = module_data[:status] == 'success' ? '✅' : '❌'
        output += "│ #{status} #{module_name.to_s.ljust(20)} │ #{module_data[:summary]&.ljust(36)} │\n"
      end
    end
    
    output += "├───────────────────────────────────────────────────────────────────┤\n"
    output += "│ Key Findings:                                                     │\n"
    
    if data[:key_findings]&.any?
      data[:key_findings].each do |finding|
        output += "│ • #{finding.ljust(62)}   │\n"
      end
    else
      output += "│ • No significant findings detected                                │\n"
    end
    
    output += "└───────────────────────────────────────────────────────────────────┘"
    output
  end
  
  private
  
  def format_session_time(time)
    return 'Unknown' unless time
    
    if time.is_a?(String)
      time
    else
      time.strftime('%H:%M:%S')
    end
  end
  
  def truncate_target(target)
    return 'None' unless target && target != 'None'
    
    target.length > 19 ? "#{target[0..16]}..." : target
  end
end
