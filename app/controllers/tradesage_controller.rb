# frozen_string_literal: true

class TradesageController < ApplicationController
  before_action :find_tradesage_agent
  before_action :ensure_demo_user

  def index
    # Main agent page with financial dashboard
    @agent_stats = {
      total_conversations: 3247,
      average_rating: 4.9,
      response_time: '< 1.5s',
      specializations: ['Stock Analysis', 'Portfolio Management', 'Risk Assessment', 'Market Prediction']
    }

    @market_data = {
      trending_stocks: generate_trending_stocks,
      market_sentiment: calculate_market_sentiment,
      portfolio_suggestions: generate_portfolio_suggestions
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
      # Generate response using financial AI
      response = generate_financial_response(user_message)

      render json: {
        success: true,
        response: response[:text],
        market_data: response[:market_data],
        charts: response[:charts],
        recommendations: response[:recommendations],
        processing_time: response[:processing_time],
        agent_name: 'TradeSage',
        timestamp: Time.current.strftime('%H:%M:%S')
      }
    rescue StandardError => e
      Rails.logger.error "TradeSage Error: #{e.message}"

      render json: {
        error: 'Sorry, I encountered an error processing your financial query. Please try again.',
        timestamp: Time.current.strftime('%H:%M:%S')
      }, status: :internal_server_error
    end
  end

  def analyze_stock
    symbol = params[:symbol]&.upcase&.strip
    timeframe = params[:timeframe] || '1M'

    if symbol.blank?
      render json: { error: 'Stock symbol is required' }, status: :bad_request
      return
    end

    analysis = perform_stock_analysis(symbol, timeframe)

    render json: {
      success: true,
      symbol:,
      analysis:,
      timestamp: Time.current.strftime('%H:%M:%S')
    }
  end

  def portfolio_analysis
    holdings = params[:holdings] || []
    total_value = params[:total_value]&.to_f || 100_000

    if holdings.empty?
      render json: { error: 'Portfolio holdings are required' }, status: :bad_request
      return
    end

    analysis = analyze_portfolio(holdings, total_value)

    render json: {
      success: true,
      portfolio_analysis: analysis,
      recommendations: generate_portfolio_recommendations(analysis),
      timestamp: Time.current.strftime('%H:%M:%S')
    }
  end

  def market_sentiment
    sector = params[:sector] || 'overall'

    sentiment = calculate_detailed_sentiment(sector)

    render json: {
      success: true,
      sector:,
      sentiment:,
      timestamp: Time.current.strftime('%H:%M:%S')
    }
  end

  def risk_assessment
    investment_type = params[:investment_type] || 'stocks'
    amount = params[:amount]&.to_f || 10_000
    timeframe = params[:timeframe] || '1Y'

    assessment = perform_risk_assessment(investment_type, amount, timeframe)

    render json: {
      success: true,
      risk_assessment: assessment,
      timestamp: Time.current.strftime('%H:%M:%S')
    }
  end

  def generate_strategy
    goal = params[:goal] || 'growth'
    risk_tolerance = params[:risk_tolerance] || 'moderate'
    timeframe = params[:timeframe] || '5Y'
    capital = params[:capital]&.to_f || 50_000

    strategy = create_investment_strategy(goal, risk_tolerance, timeframe, capital)

    render json: {
      success: true,
      strategy:,
      timestamp: Time.current.strftime('%H:%M:%S')
    }
  end

  def market_news
    category = params[:category] || 'general'
    limit = params[:limit]&.to_i || 10

    news = fetch_market_news(category, limit)

    render json: {
      success: true,
      news:,
      category:,
      timestamp: Time.current.strftime('%H:%M:%S')
    }
  end

  def technical_analysis
    symbol = params[:symbol]&.upcase&.strip
    indicators = params[:indicators] || %w[RSI MACD SMA EMA]

    if symbol.blank?
      render json: { error: 'Stock symbol is required' }, status: :bad_request
      return
    end

    analysis = perform_technical_analysis(symbol, indicators)

    render json: {
      success: true,
      symbol:,
      technical_analysis: analysis,
      signals: generate_trading_signals(analysis),
      timestamp: Time.current.strftime('%H:%M:%S')
    }
  end

  def status
    # Agent status endpoint for monitoring
    render json: {
      agent: 'TradeSage',
      status: 'active',
      uptime: '99.8%',
      capabilities: [
        'Stock Analysis',
        'Portfolio Management',
        'Risk Assessment',
        'Market Sentiment Analysis',
        'Technical Analysis',
        'Investment Strategy Generation'
      ],
      data_sources: [
        'Real-time Market Data',
        'Financial News APIs',
        'Economic Indicators',
        'Company Fundamentals'
      ],
      last_active: Time.current.strftime('%Y-%m-%d %H:%M:%S')
    }
  end

  private

  def find_tradesage_agent
    # For now, we'll simulate the agent
    @agent = nil
  end

  def ensure_demo_user
    # Create or find a demo user for the session
    session_id = session[:user_session_id] ||= SecureRandom.uuid

    @user = {
      id: session_id,
      name: "TradeSage User #{rand(1000..9999)}",
      preferences: {
        communication_style: 'terminal',
        interface_theme: 'dark',
        response_detail: 'comprehensive'
      }
    }

    session[:current_user_id] = @user[:id]
  end

  def generate_financial_response(message)
    message_lower = message.downcase

    response_text = if message_lower.include?('portfolio') || message_lower.include?('diversif')
                      "I can help you analyze and optimize your investment portfolio. Share your current holdings and I'll provide detailed analysis with recommendations for better diversification and risk management."
                    elsif message_lower.include?('stock') || message_lower.include?('ticker')
                      "I'm ready to analyze any stock for you! Provide a ticker symbol and I'll give you comprehensive analysis including technical indicators, fundamental analysis, and price predictions."
                    elsif message_lower.include?('risk') || message_lower.include?('volatility')
                      'Risk assessment is crucial for successful investing. I can evaluate the risk profile of any investment, calculate VaR (Value at Risk), and suggest appropriate position sizing.'
                    elsif message_lower.include?('market') || message_lower.include?('trend')
                      'Market analysis is my specialty! I track sentiment across all major sectors, analyze economic indicators, and provide trend predictions based on technical and fundamental data.'
                    else
                      "Welcome to TradeSage! I'm your AI financial advisor specializing in market analysis, portfolio optimization, and investment strategy. How can I help you with your trading and investment decisions today?"
                    end

    {
      text: response_text,
      market_data: generate_sample_market_data,
      charts: generate_sample_charts,
      recommendations: generate_sample_recommendations,
      processing_time: "#{rand(800..1800)}ms"
    }
  end

  def generate_trending_stocks
    [
      { symbol: 'AAPL', name: 'Apple Inc.', price: 175.43, change: '+2.34%', volume: '52.3M' },
      { symbol: 'MSFT', name: 'Microsoft Corp.', price: 378.85, change: '+1.87%', volume: '28.7M' },
      { symbol: 'GOOGL', name: 'Alphabet Inc.', price: 142.56, change: '-0.45%', volume: '31.2M' },
      { symbol: 'AMZN', name: 'Amazon.com Inc.', price: 168.91, change: '+3.21%', volume: '45.8M' },
      { symbol: 'TSLA', name: 'Tesla Inc.', price: 248.42, change: '+5.67%', volume: '89.4M' }
    ]
  end

  def calculate_market_sentiment
    {
      overall: 'Bullish',
      score: 72,
      sectors: {
        'Technology' => { sentiment: 'Very Bullish', score: 85 },
        'Healthcare' => { sentiment: 'Bullish', score: 68 },
        'Finance' => { sentiment: 'Neutral', score: 52 },
        'Energy' => { sentiment: 'Bearish', score: 38 },
        'Real Estate' => { sentiment: 'Neutral', score: 55 }
      }
    }
  end

  def generate_portfolio_suggestions
    [
      { allocation: 'Large Cap Growth', percentage: 35, rationale: 'Stable growth with lower volatility' },
      { allocation: 'International Developed', percentage: 20, rationale: 'Geographic diversification' },
      { allocation: 'Emerging Markets', percentage: 15, rationale: 'Higher growth potential' },
      { allocation: 'Bonds', percentage: 20, rationale: 'Income generation and stability' },
      { allocation: 'REITs', percentage: 10, rationale: 'Inflation hedge and income' }
    ]
  end

  def perform_stock_analysis(_symbol, _timeframe)
    # Simulate comprehensive stock analysis
    {
      fundamental_analysis: {
        pe_ratio: rand(15.0..35.0).round(2),
        pb_ratio: rand(1.5..5.0).round(2),
        debt_to_equity: rand(0.2..2.0).round(2),
        roe: rand(10.0..25.0).round(1),
        revenue_growth: rand(-5.0..25.0).round(1),
        eps_growth: rand(-10.0..30.0).round(1)
      },
      technical_analysis: {
        trend: %w[Bullish Bearish Sideways].sample,
        support_level: rand(100.0..200.0).round(2),
        resistance_level: rand(200.0..300.0).round(2),
        rsi: rand(30.0..70.0).round(1),
        macd_signal: %w[Buy Sell Hold].sample
      },
      price_prediction: {
        next_week: rand(-5.0..8.0).round(2),
        next_month: rand(-10.0..15.0).round(2),
        next_quarter: rand(-15.0..25.0).round(2)
      },
      recommendation: ['Strong Buy', 'Buy', 'Hold', 'Sell'].sample,
      confidence_score: rand(70..95)
    }
  end

  def analyze_portfolio(holdings, total_value)
    total_allocation = holdings.sum { |holding| holding['percentage'].to_f }

    {
      total_value:,
      total_allocation:,
      diversification_score: calculate_diversification_score(holdings),
      risk_score: calculate_portfolio_risk(holdings),
      expected_return: rand(8.0..12.0).round(2),
      volatility: rand(15.0..25.0).round(2),
      sharpe_ratio: rand(0.8..1.5).round(2),
      sector_allocation: analyze_sector_allocation(holdings),
      geographic_allocation: analyze_geographic_allocation(holdings)
    }
  end

  def calculate_diversification_score(holdings)
    # Simple diversification calculation
    num_holdings = holdings.length
    base_score = [num_holdings * 10, 100].min

    # Penalize over-concentration
    max_allocation = holdings.map { |h| h['percentage'].to_f }.max
    penalty = max_allocation > 25 ? (max_allocation - 25) * 2 : 0

    [base_score - penalty, 0].max.round(1)
  end

  def calculate_portfolio_risk(holdings)
    # Simulate risk calculation based on holdings
    avg_allocation = holdings.map { |h| h['percentage'].to_f }.sum / holdings.length
    risk_multiplier = avg_allocation > 20 ? 1.5 : 1.0

    base_risk = rand(3.5..8.5)
    (base_risk * risk_multiplier).round(1)
  end

  def analyze_sector_allocation(_holdings)
    {
      'Technology' => rand(20..40),
      'Healthcare' => rand(10..25),
      'Financial' => rand(10..20),
      'Consumer' => rand(5..15),
      'Industrial' => rand(5..15),
      'Energy' => rand(0..10),
      'Utilities' => rand(0..10),
      'Real Estate' => rand(0..10)
    }
  end

  def analyze_geographic_allocation(_holdings)
    {
      'US' => rand(60..80),
      'International Developed' => rand(15..25),
      'Emerging Markets' => rand(5..15),
      'Other' => rand(0..5)
    }
  end

  def generate_portfolio_recommendations(analysis)
    recommendations = []

    if analysis[:diversification_score] < 70
      recommendations << {
        type: 'diversification',
        priority: 'high',
        message: 'Consider adding more diverse holdings to reduce concentration risk'
      }
    end

    if analysis[:risk_score] > 7
      recommendations << {
        type: 'risk',
        priority: 'medium',
        message: 'Portfolio risk is elevated. Consider adding defensive positions'
      }
    end

    recommendations << {
      type: 'rebalancing',
      priority: 'low',
      message: 'Schedule quarterly rebalancing to maintain target allocations'
    }

    recommendations
  end

  def calculate_detailed_sentiment(_sector)
    base_sentiment = rand(30..85)

    {
      current_score: base_sentiment,
      trend: base_sentiment > 60 ? 'Improving' : 'Declining',
      confidence: rand(70..95),
      key_factors: [
        'Economic indicators showing strength',
        'Corporate earnings beating expectations',
        'Federal Reserve policy remains supportive'
      ],
      market_drivers: [
        'Technology sector leading gains',
        'Consumer spending remains robust',
        'International trade tensions easing'
      ]
    }
  end

  def perform_risk_assessment(investment_type, amount, timeframe)
    # Calculate risk based on investment type and timeframe
    risk_multipliers = {
      'stocks' => 1.0,
      'crypto' => 2.5,
      'bonds' => 0.3,
      'commodities' => 1.8,
      'forex' => 2.0
    }

    time_multipliers = {
      '1M' => 1.5,
      '3M' => 1.2,
      '1Y' => 1.0,
      '5Y' => 0.8,
      '10Y' => 0.6
    }

    base_var = amount * 0.05 # 5% base VaR
    risk_factor = (risk_multipliers[investment_type] || 1.0) * (time_multipliers[timeframe] || 1.0)

    {
      value_at_risk: {
        daily: (base_var * risk_factor * 0.1).round(2),
        weekly: (base_var * risk_factor * 0.25).round(2),
        monthly: (base_var * risk_factor).round(2)
      },
      risk_level: determine_risk_level(risk_factor),
      maximum_drawdown: (base_var * risk_factor * 2).round(2),
      volatility: (risk_factor * 15).round(1),
      recommendations: generate_risk_recommendations(risk_factor)
    }
  end

  def determine_risk_level(risk_factor)
    case risk_factor
    when 0..0.5
      'Very Low'
    when 0.5..1.0
      'Low'
    when 1.0..1.5
      'Moderate'
    when 1.5..2.0
      'High'
    else
      'Very High'
    end
  end

  def generate_risk_recommendations(risk_factor)
    if risk_factor > 2.0
      ['Consider diversification', 'Reduce position size', 'Add hedging instruments']
    elsif risk_factor > 1.5
      ['Monitor closely', 'Consider stop-loss orders', 'Review position sizing']
    else
      ['Maintain current strategy', 'Monitor market conditions', 'Consider gradual scaling']
    end
  end

  def create_investment_strategy(goal, risk_tolerance, timeframe, capital)
    # Generate comprehensive investment strategy
    {
      strategy_name: "#{goal.capitalize} Strategy - #{risk_tolerance.capitalize} Risk",
      asset_allocation: generate_asset_allocation(goal, risk_tolerance, timeframe),
      expected_return: calculate_expected_return(goal, risk_tolerance, timeframe),
      risk_profile: risk_tolerance,
      rebalancing_frequency: determine_rebalancing_frequency(timeframe),
      investment_approach: determine_investment_approach(goal, timeframe),
      specific_recommendations: generate_specific_recommendations(goal, capital),
      milestones: generate_strategy_milestones(goal, timeframe, capital)
    }
  end

  def generate_asset_allocation(_goal, risk_tolerance, _timeframe)
    case risk_tolerance
    when 'conservative'
      { stocks: 30, bonds: 60, alternatives: 10 }
    when 'moderate'
      { stocks: 60, bonds: 30, alternatives: 10 }
    when 'aggressive'
      { stocks: 80, bonds: 10, alternatives: 10 }
    else
      { stocks: 50, bonds: 40, alternatives: 10 }
    end
  end

  def calculate_expected_return(_goal, risk_tolerance, timeframe)
    base_returns = {
      'conservative' => 6.5,
      'moderate' => 8.5,
      'aggressive' => 11.0
    }

    base_return = base_returns[risk_tolerance] || 8.0

    # Adjust for timeframe
    if timeframe.include?('Y')
      years = timeframe.to_i
      time_adjustment = years > 5 ? 0.5 : 0
    else
      time_adjustment = -1.0 # Short-term has lower expected returns
    end

    (base_return + time_adjustment).round(1)
  end

  def determine_rebalancing_frequency(timeframe)
    if timeframe.include?('Y') && timeframe.to_i >= 5
      'Quarterly'
    elsif timeframe.include?('Y')
      'Monthly'
    else
      'Weekly'
    end
  end

  def determine_investment_approach(goal, timeframe)
    if goal == 'income'
      'Dividend Growth Investing'
    elsif goal == 'growth' && timeframe.include?('Y') && timeframe.to_i >= 10
      'Buy and Hold'
    else
      'Growth Investing'
    end
  end

  def generate_specific_recommendations(goal, capital)
    base_recommendations = [
      'Start with low-cost index funds',
      'Maintain emergency fund before investing',
      'Consider tax-advantaged accounts first'
    ]

    if capital > 100_000
      base_recommendations << 'Consider individual stock picking'
      base_recommendations << 'Explore alternative investments'
    end

    if goal == 'retirement'
      base_recommendations << 'Maximize employer 401k match'
      base_recommendations << 'Consider Roth IRA conversion strategies'
    end

    base_recommendations
  end

  def generate_strategy_milestones(_goal, timeframe, capital)
    milestones = []

    if timeframe.include?('Y')
      years = timeframe.to_i

      (1..years).each do |year|
        milestone_value = capital * 1.08**year
        milestones << {
          year:,
          target_value: milestone_value.round(2),
          description: "Year #{year}: Reach $#{milestone_value.round(0).to_s.reverse.gsub(/(\d{3})(?=\d)/,
                                                                                          '\\1,').reverse}"
        }
      end
    end

    milestones
  end

  def fetch_market_news(_category, limit)
    # Simulate market news
    news_items = [
      {
        title: 'Federal Reserve Signals Potential Rate Cuts',
        summary: 'Latest FOMC meeting minutes suggest policy makers are considering rate reductions...',
        source: 'Financial Times',
        timestamp: 2.hours.ago,
        impact: 'positive'
      },
      {
        title: 'Tech Stocks Rally on AI Breakthrough',
        summary: 'Major technology companies see significant gains following latest AI developments...',
        source: 'Wall Street Journal',
        timestamp: 4.hours.ago,
        impact: 'positive'
      },
      {
        title: 'Inflation Data Shows Continued Cooling',
        summary: 'Consumer Price Index comes in below expectations for third consecutive month...',
        source: 'Reuters',
        timestamp: 6.hours.ago,
        impact: 'positive'
      }
    ]

    news_items.first(limit)
  end

  def perform_technical_analysis(_symbol, indicators)
    analysis = {}

    indicators.each do |indicator|
      case indicator
      when 'RSI'
        rsi_value = rand(30.0..70.0).round(1)
        analysis['RSI'] = {
          value: rsi_value,
          signal: if rsi_value < 30
                    'Oversold'
                  else
                    rsi_value > 70 ? 'Overbought' : 'Neutral'
                  end
        }
      when 'MACD'
        analysis['MACD'] = {
          value: rand(-2.0..2.0).round(2),
          signal: ['Bullish Crossover', 'Bearish Crossover', 'Neutral'].sample
        }
      when 'SMA'
        analysis['SMA'] = {
          sma_20: rand(150.0..200.0).round(2),
          sma_50: rand(140.0..190.0).round(2),
          signal: ['Above SMA', 'Below SMA'].sample
        }
      when 'EMA'
        analysis['EMA'] = {
          ema_12: rand(155.0..195.0).round(2),
          ema_26: rand(145.0..185.0).round(2),
          signal: %w[Bullish Bearish].sample
        }
      end
    end

    analysis
  end

  def generate_trading_signals(analysis)
    signals = []

    analysis.each do |indicator, data|
      case indicator
      when 'RSI'
        if data[:signal] == 'Oversold'
          signals << { type: 'BUY', strength: 'Strong', reason: 'RSI indicates oversold condition' }
        elsif data[:signal] == 'Overbought'
          signals << { type: 'SELL', strength: 'Strong', reason: 'RSI indicates overbought condition' }
        end
      when 'MACD'
        if data[:signal].include?('Bullish')
          signals << { type: 'BUY', strength: 'Medium', reason: 'MACD bullish crossover' }
        elsif data[:signal].include?('Bearish')
          signals << { type: 'SELL', strength: 'Medium', reason: 'MACD bearish crossover' }
        end
      end
    end

    signals.empty? ? [{ type: 'HOLD', strength: 'Medium', reason: 'Mixed signals, maintain position' }] : signals
  end

  def generate_sample_market_data
    {
      sp500: { value: 4847.29, change: '+0.87%' },
      nasdaq: { value: 15_234.45, change: '+1.23%' },
      dow: { value: 38_109.43, change: '+0.45%' },
      vix: { value: 13.45, change: '-2.34%' }
    }
  end

  def generate_sample_charts
    [
      { type: 'line', title: 'Portfolio Performance', timeframe: '1Y' },
      { type: 'pie', title: 'Asset Allocation', data: 'current_holdings' },
      { type: 'bar', title: 'Sector Performance', timeframe: '1M' }
    ]
  end

  def generate_sample_recommendations
    [
      { action: 'BUY', symbol: 'AAPL', confidence: 85, reason: 'Strong fundamentals and technical setup' },
      { action: 'HOLD', symbol: 'MSFT', confidence: 72, reason: 'Awaiting earnings clarity' },
      { action: 'SELL', symbol: 'AMZN', confidence: 68, reason: 'Overvalued at current levels' }
    ]
  end
end
