# Enterprise Payment Processing Service
class PaymentService
  def initialize(provider: :stripe)
    @provider = provider.to_sym
    validate_provider!
  end

  # Process payment with selected provider
  def process_payment(amount, currency: 'usd', **options)
    case @provider
    when :stripe
      process_stripe_payment(amount, currency, options)
    when :paypal
      process_paypal_payment(amount, currency, options)
    when :lemonsqueezy
      process_lemonsqueezy_payment(amount, currency, options)
    else
      raise UnsupportedProviderError, "Provider #{@provider} is not supported"
    end
  end

  # Create subscription
  def create_subscription(customer_id, plan_id, **options)
    case @provider
    when :stripe
      create_stripe_subscription(customer_id, plan_id, options)
    when :lemonsqueezy
      create_lemonsqueezy_subscription(customer_id, plan_id, options)
    else
      raise UnsupportedOperationError, "Subscriptions not supported for #{@provider}"
    end
  end

  # Handle webhooks
  def handle_webhook(payload, signature, endpoint_secret)
    case @provider
    when :stripe
      handle_stripe_webhook(payload, signature, endpoint_secret)
    when :paypal
      handle_paypal_webhook(payload, signature)
    when :lemonsqueezy
      handle_lemonsqueezy_webhook(payload, signature)
    end
  end

  private

  def validate_provider!
    unless [:stripe, :paypal, :lemonsqueezy].include?(@provider)
      raise InvalidProviderError, "Unknown payment provider: #{@provider}"
    end
  end

  # Stripe Implementation
  def process_stripe_payment(amount, currency, options)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    
    begin
      payment_intent = Stripe::PaymentIntent.create({
        amount: (amount * 100).to_i, # Convert to cents
        currency: currency,
        payment_method: options[:payment_method],
        confirmation_method: 'manual',
        confirm: true,
        return_url: options[:return_url],
        metadata: options[:metadata] || {}
      })
      
      {
        success: true,
        payment_id: payment_intent.id,
        status: payment_intent.status,
        client_secret: payment_intent.client_secret
      }
    rescue Stripe::CardError => e
      {
        success: false,
        error: e.message,
        decline_code: e.decline_code
      }
    rescue Stripe::StripeError => e
      {
        success: false,
        error: e.message
      }
    end
  end

  def create_stripe_subscription(customer_id, plan_id, options)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    
    begin
      subscription = Stripe::Subscription.create({
        customer: customer_id,
        items: [{ price: plan_id }],
        expand: ['latest_invoice.payment_intent'],
        trial_period_days: options[:trial_days],
        metadata: options[:metadata] || {}
      })
      
      {
        success: true,
        subscription_id: subscription.id,
        status: subscription.status,
        current_period_end: subscription.current_period_end
      }
    rescue Stripe::StripeError => e
      {
        success: false,
        error: e.message
      }
    end
  end

  def handle_stripe_webhook(payload, signature, endpoint_secret)
    begin
      event = Stripe::Webhook.construct_event(payload, signature, endpoint_secret)
      
      case event['type']
      when 'payment_intent.succeeded'
        handle_successful_payment(event['data']['object'])
      when 'payment_intent.payment_failed'
        handle_failed_payment(event['data']['object'])
      when 'customer.subscription.created'
        handle_subscription_created(event['data']['object'])
      when 'customer.subscription.deleted'
        handle_subscription_cancelled(event['data']['object'])
      when 'invoice.payment_succeeded'
        handle_invoice_paid(event['data']['object'])
      end
      
      { success: true }
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      { success: false, error: e.message }
    end
  end

  # PayPal Implementation
  def process_paypal_payment(amount, currency, options)
    require 'paypal-checkout-sdk'
    
    client = paypal_client
    
    request = PayPalCheckoutSdk::Orders::OrdersCreateRequest.new
    request.prefer('return=representation')
    request.request_body({
      intent: 'CAPTURE',
      purchase_units: [{
        amount: {
          currency_code: currency.upcase,
          value: amount.to_s
        },
        description: options[:description] || 'OneLastAI Payment'
      }],
      application_context: {
        return_url: options[:return_url],
        cancel_url: options[:cancel_url]
      }
    })
    
    begin
      response = client.execute(request)
      
      {
        success: true,
        payment_id: response.result.id,
        status: response.result.status,
        approval_url: response.result.links.find { |link| link.rel == 'approve' }&.href
      }
    rescue PayPalHttp::HttpError => e
      {
        success: false,
        error: e.message
      }
    end
  end

  def handle_paypal_webhook(payload, signature)
    # PayPal webhook verification and handling
    parsed_payload = JSON.parse(payload)
    
    case parsed_payload['event_type']
    when 'PAYMENT.CAPTURE.COMPLETED'
      handle_successful_payment(parsed_payload['resource'])
    when 'PAYMENT.CAPTURE.DENIED'
      handle_failed_payment(parsed_payload['resource'])
    end
    
    { success: true }
  rescue JSON::ParserError => e
    { success: false, error: e.message }
  end

  # Lemon Squeezy Implementation
  def process_lemonsqueezy_payment(amount, currency, options)
    headers = {
      'Authorization' => "Bearer #{ENV['LEMONSQUEEZY_API_KEY']}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/vnd.api+json'
    }
    
    payload = {
      data: {
        type: 'checkouts',
        attributes: {
          store_id: ENV['LEMONSQUEEZY_STORE_ID'],
          variant_id: options[:variant_id],
          custom_price: (amount * 100).to_i, # Convert to cents
          checkout_data: {
            custom: options[:metadata] || {}
          }
        }
      }
    }
    
    response = HTTParty.post('https://api.lemonsqueezy.com/v1/checkouts', {
      headers: headers,
      body: payload.to_json
    })
    
    if response.success?
      data = JSON.parse(response.body)['data']
      {
        success: true,
        checkout_id: data['id'],
        checkout_url: data['attributes']['url']
      }
    else
      {
        success: false,
        error: response.body
      }
    end
  end

  def create_lemonsqueezy_subscription(customer_id, plan_id, options)
    headers = {
      'Authorization' => "Bearer #{ENV['LEMONSQUEEZY_API_KEY']}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/vnd.api+json'
    }
    
    payload = {
      data: {
        type: 'subscriptions',
        attributes: {
          store_id: ENV['LEMONSQUEEZY_STORE_ID'],
          customer_id: customer_id,
          variant_id: plan_id,
          trial_ends_at: options[:trial_ends_at]
        }
      }
    }
    
    response = HTTParty.post('https://api.lemonsqueezy.com/v1/subscriptions', {
      headers: headers,
      body: payload.to_json
    })
    
    if response.success?
      data = JSON.parse(response.body)['data']
      {
        success: true,
        subscription_id: data['id'],
        status: data['attributes']['status']
      }
    else
      {
        success: false,
        error: response.body
      }
    end
  end

  def handle_lemonsqueezy_webhook(payload, signature)
    # Verify webhook signature
    expected_signature = OpenSSL::HMAC.hexdigest('SHA256', ENV['LEMONSQUEEZY_WEBHOOK_SECRET'], payload)
    
    unless Rack::Utils.secure_compare(signature, expected_signature)
      return { success: false, error: 'Invalid signature' }
    end
    
    parsed_payload = JSON.parse(payload)
    
    case parsed_payload['meta']['event_name']
    when 'order_created'
      handle_successful_payment(parsed_payload['data'])
    when 'subscription_created'
      handle_subscription_created(parsed_payload['data'])
    when 'subscription_cancelled'
      handle_subscription_cancelled(parsed_payload['data'])
    end
    
    { success: true }
  rescue JSON::ParserError => e
    { success: false, error: e.message }
  end

  # Shared webhook handlers
  def handle_successful_payment(payment_data)
    # Update user account, grant access, send confirmation email
    Rails.logger.info "Payment successful: #{payment_data['id']}"
    
    # Trigger background job for post-payment processing
    PaymentSuccessJob.perform_later(payment_data)
  end

  def handle_failed_payment(payment_data)
    # Log failed payment, notify user, update payment status
    Rails.logger.warn "Payment failed: #{payment_data['id']}"
    
    # Trigger background job for failed payment handling
    PaymentFailureJob.perform_later(payment_data)
  end

  def handle_subscription_created(subscription_data)
    # Activate subscription, grant premium access
    Rails.logger.info "Subscription created: #{subscription_data['id']}"
    
    # Trigger background job for subscription activation
    SubscriptionActivationJob.perform_later(subscription_data)
  end

  def handle_subscription_cancelled(subscription_data)
    # Deactivate subscription, revoke premium access
    Rails.logger.info "Subscription cancelled: #{subscription_data['id']}"
    
    # Trigger background job for subscription cancellation
    SubscriptionCancellationJob.perform_later(subscription_data)
  end

  def handle_invoice_paid(invoice_data)
    # Process recurring payment, extend subscription
    Rails.logger.info "Invoice paid: #{invoice_data['id']}"
    
    # Trigger background job for invoice processing
    InvoiceProcessingJob.perform_later(invoice_data)
  end

  # Helper methods
  def paypal_client
    environment = ENV['PAYPAL_ENVIRONMENT'] == 'live' ? 
      PayPal::SandboxEnvironment.new(ENV['PAYPAL_CLIENT_ID'], ENV['PAYPAL_CLIENT_SECRET']) :
      PayPal::LiveEnvironment.new(ENV['PAYPAL_CLIENT_ID'], ENV['PAYPAL_CLIENT_SECRET'])
    
    PayPal::PayPalHttpClient.new(environment)
  end

  # Custom exception classes
  class PaymentError < StandardError; end
  class InvalidProviderError < PaymentError; end
  class UnsupportedProviderError < PaymentError; end
  class UnsupportedOperationError < PaymentError; end
end
