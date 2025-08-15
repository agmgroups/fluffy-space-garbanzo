#!/bin/bash

# OneLastAI Setup Script
# This script helps you set up the OneLastAI application for development or production

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Print banner
print_banner() {
    echo -e "${BLUE}"
    echo "  ██████  ███    ██ ███████ ██       █████  ███████ ████████  █████  ██"
    echo " ██    ██ ████   ██ ██      ██      ██   ██ ██         ██    ██   ██ ██"
    echo " ██    ██ ██ ██  ██ █████   ██      ███████ ███████    ██    ███████ ██"
    echo " ██    ██ ██  ██ ██ ██      ██      ██   ██      ██    ██    ██   ██ ██"
    echo "  ██████  ██   ████ ███████ ███████ ██   ██ ███████    ██    ██   ██ ██"
    echo ""
    echo "                    AI Agent Network Platform"
    echo -e "${NC}"
}

# Check system requirements
check_requirements() {
    log_info "Checking system requirements..."
    
    local requirements_met=true
    
    # Check Ruby
    if command_exists ruby; then
        ruby_version=$(ruby -v | cut -d' ' -f2)
        log_success "Ruby $ruby_version found"
    else
        log_error "Ruby not found. Please install Ruby 3.3.0 or later"
        requirements_met=false
    fi
    
    # Check Bundler
    if command_exists bundle; then
        bundler_version=$(bundle -v | cut -d' ' -f3)
        log_success "Bundler $bundler_version found"
    else
        log_error "Bundler not found. Run: gem install bundler"
        requirements_met=false
    fi
    
    # Check Node.js (optional but recommended)
    if command_exists node; then
        node_version=$(node -v)
        log_success "Node.js $node_version found"
    else
        log_warning "Node.js not found. Some features may be limited"
    fi
    
    # Check Git
    if command_exists git; then
        log_success "Git found"
    else
        log_error "Git not found. Please install Git"
        requirements_met=false
    fi
    
    if [ "$requirements_met" = false ]; then
        log_error "Some requirements are missing. Please install them and run the script again."
        exit 1
    fi
}

# Create environment file
setup_environment() {
    log_info "Setting up environment configuration..."
    
    if [ ! -f .env ]; then
        if [ -f .env.example ]; then
            cp .env.example .env
            log_success "Created .env file from template"
            log_warning "Please edit .env file and add your API keys and configuration"
        else
            log_error ".env.example file not found"
            exit 1
        fi
    else
        log_info ".env file already exists"
    fi
}

# Install dependencies
install_dependencies() {
    log_info "Installing Ruby dependencies..."
    
    if bundle check >/dev/null 2>&1; then
        log_info "Dependencies already installed"
    else
        bundle install
        log_success "Dependencies installed successfully"
    fi
}

# Setup database
setup_database() {
    log_info "Setting up database..."
    
    # Check if database exists
    if bundle exec rails runner "ActiveRecord::Base.connection" >/dev/null 2>&1; then
        log_info "Database already exists"
    else
        bundle exec rails db:create
        log_success "Database created"
    fi
    
    # Run migrations
    bundle exec rails db:migrate
    log_success "Database migrations completed"
    
    # Seed database if needed
    if [ -f db/seeds.rb ]; then
        bundle exec rails db:seed
        log_success "Database seeded"
    fi
}

# Check Redis
check_redis() {
    log_info "Checking Redis connection..."
    
    if command_exists redis-cli; then
        if redis-cli ping >/dev/null 2>&1; then
            log_success "Redis is running"
        else
            log_warning "Redis is not running. Some features may not work properly"
            log_info "To start Redis:"
            log_info "  macOS: brew services start redis"
            log_info "  Ubuntu: sudo systemctl start redis-server"
            log_info "  Docker: docker run -d -p 6379:6379 redis:alpine"
        fi
    else
        log_warning "Redis CLI not found. Install Redis for full functionality"
    fi
}

# Generate secret key
generate_secrets() {
    log_info "Generating application secrets..."
    
    if grep -q "your_secret_key_base_here" .env 2>/dev/null; then
        secret_key=$(bundle exec rails secret)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s/your_secret_key_base_here/$secret_key/" .env
        else
            # Linux
            sed -i "s/your_secret_key_base_here/$secret_key/" .env
        fi
        log_success "Secret key generated and updated in .env"
    else
        log_info "Secret key already configured"
    fi
}

# Precompile assets
precompile_assets() {
    log_info "Precompiling assets..."
    
    bundle exec rails assets:precompile
    log_success "Assets precompiled successfully"
}

# Run tests
run_tests() {
    if [ "$1" = "--skip-tests" ]; then
        log_info "Skipping tests as requested"
        return
    fi
    
    log_info "Running tests..."
    
    if bundle exec rails test >/dev/null 2>&1; then
        log_success "All tests passed"
    else
        log_warning "Some tests failed. Check the output above"
    fi
}

# Start services
start_services() {
    log_info "Application setup completed!"
    log_info ""
    log_info "To start the application:"
    log_info "  bundle exec rails server"
    log_info ""
    log_info "The application will be available at:"
    log_info "  http://localhost:3000"
    log_info ""
    log_info "Don't forget to:"
    log_info "  1. Edit .env file with your API keys"
    log_info "  2. Start Redis if you haven't already"
    log_info "  3. Check the logs for any configuration warnings"
}

# Docker setup
setup_docker() {
    log_info "Setting up Docker environment..."
    
    if command_exists docker; then
        log_success "Docker found"
        
        if [ -f docker-compose.yml ]; then
            log_info "Building and starting containers..."
            docker-compose up --build -d
            log_success "Docker containers started"
        else
            log_warning "docker-compose.yml not found"
        fi
    else
        log_warning "Docker not found. Install Docker for containerized deployment"
    fi
}

# Production setup
setup_production() {
    log_info "Setting up for production deployment..."
    
    # Check production requirements
    local prod_requirements=true
    
    if [ -z "$SECRET_KEY_BASE" ]; then
        log_error "SECRET_KEY_BASE environment variable not set"
        prod_requirements=false
    fi
    
    if [ -z "$DATABASE_URL" ]; then
        log_error "DATABASE_URL environment variable not set"
        prod_requirements=false
    fi
    
    if [ "$prod_requirements" = false ]; then
        log_error "Production requirements not met"
        exit 1
    fi
    
    # Run production setup
    bundle exec rails db:migrate RAILS_ENV=production
    bundle exec rails assets:precompile RAILS_ENV=production
    
    log_success "Production setup completed"
}

# Display help
show_help() {
    echo "OneLastAI Setup Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --development     Setup for development (default)"
    echo "  --production      Setup for production"
    echo "  --docker          Setup with Docker"
    echo "  --skip-tests      Skip running tests"
    echo "  --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                   # Development setup"
    echo "  $0 --production      # Production setup"
    echo "  $0 --docker          # Docker setup"
}

# Main setup function
main() {
    local mode="development"
    local skip_tests=false
    local use_docker=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --development)
                mode="development"
                shift
                ;;
            --production)
                mode="production"
                shift
                ;;
            --docker)
                use_docker=true
                shift
                ;;
            --skip-tests)
                skip_tests=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    print_banner
    
    log_info "Starting OneLastAI setup in $mode mode..."
    
    check_requirements
    setup_environment
    
    if [ "$use_docker" = true ]; then
        setup_docker
    else
        install_dependencies
        generate_secrets
        setup_database
        check_redis
        
        if [ "$mode" = "production" ]; then
            setup_production
        else
            precompile_assets
            run_tests "$skip_tests"
            start_services
        fi
    fi
    
    log_success "Setup completed successfully!"
}

# Run main function
main "$@"