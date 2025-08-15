import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["email", "button"]

  connect() {
    this.addEventListeners()
  }

  addEventListeners() {
    const form = this.element.querySelector('.form-container')
    if (form) {
      form.addEventListener('submit', this.handleSubmit.bind(this))
    }

    const button = this.element.querySelector('.newsletter-button')
    if (button) {
      button.addEventListener('click', this.handleSubmit.bind(this))
    }
  }

  handleSubmit(event) {
    event.preventDefault()
    
    const emailInput = this.element.querySelector('.newsletter-input')
    const email = emailInput ? emailInput.value.trim() : ''
    
    if (!email) {
      this.showMessage('Please enter your email address', 'error')
      return
    }
    
    if (!this.isValidEmail(email)) {
      this.showMessage('Please enter a valid email address', 'error')
      return
    }
    
    // Simulate subscription process
    this.showLoading()
    
    setTimeout(() => {
      this.showMessage('Thank you for subscribing! Check your email for confirmation.', 'success')
      if (emailInput) emailInput.value = ''
    }, 1500)
  }

  isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  showLoading() {
    const button = this.element.querySelector('.newsletter-button')
    if (button) {
      button.textContent = 'Subscribing...'
      button.disabled = true
    }
  }

  showMessage(message, type) {
    const button = this.element.querySelector('.newsletter-button')
    if (button) {
      button.textContent = 'Subscribe to Updates'
      button.disabled = false
    }

    // Create or update message element
    let messageElement = this.element.querySelector('.newsletter-message')
    if (!messageElement) {
      messageElement = document.createElement('div')
      messageElement.className = 'newsletter-message mt-4 p-3 rounded-lg text-center transition-all duration-300'
      const formContainer = this.element.querySelector('.form-container')
      if (formContainer && formContainer.parentNode) {
        formContainer.parentNode.insertBefore(messageElement, formContainer.nextSibling)
      }
    }

    messageElement.textContent = message
    messageElement.className = `newsletter-message mt-4 p-3 rounded-lg text-center transition-all duration-300 ${
      type === 'success' 
        ? 'bg-green-500/20 border border-green-500/50 text-green-300' 
        : 'bg-red-500/20 border border-red-500/50 text-red-300'
    }`

    // Auto-hide message after 5 seconds
    setTimeout(() => {
      if (messageElement) {
        messageElement.style.opacity = '0'
        setTimeout(() => {
          if (messageElement && messageElement.parentNode) {
            messageElement.parentNode.removeChild(messageElement)
          }
        }, 300)
      }
    }, 5000)
  }
}