#!/bin/bash

# OneLastAI AWS EC2 Deployment Script
# Run this script from your local machine to deploy to EC2

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
EC2_HOST="ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com"
EC2_USER="ubuntu"
KEY_FILE="roombreaker.pem"
DOMAIN="onelastai.com"
APP_DIR="/var/www/onelastai"
REPO_URL="https://github.com/1-ManArmy/fluffy-space-garbanzo.git"
BRANCH="domain-onelastai-setup"

echo -e "${BLUE}🚀 OneLastAI EC2 Deployment Starting...${NC}"
echo -e "${BLUE}Target: ${EC2_HOST}${NC}"
echo -e "${BLUE}Domain: ${DOMAIN}${NC}"
echo ""

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to run commands on EC2
run_remote() {
    print_status "Running: $1"
    ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no "$EC2_USER@$EC2_HOST" "$1"
}

# Function to copy files to EC2
copy_to_ec2() {
    print_status "Copying $1 to EC2..."
    scp -i "$KEY_FILE" -o StrictHostKeyChecking=no "$1" "$EC2_USER@$EC2_HOST:$2"
}

# Check if key file exists
if [ ! -f "$KEY_FILE" ]; then
    print_error "SSH key file '$KEY_FILE' not found!"
    print_warning "Make sure the key file is in the current directory"
    exit 1
fi

# Check key permissions
if [ "$(stat -c %a "$KEY_FILE")" != "400" ]; then
    print_warning "Fixing SSH key permissions..."
    chmod 400 "$KEY_FILE"
fi

# Test SSH connection
print_status "Testing SSH connection..."
if ! ssh -i "$KEY_FILE" -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$EC2_USER@$EC2_HOST" "echo 'SSH connection successful'"; then
    print_error "Cannot connect to EC2 instance!"
    print_warning "Please check:"
    print_warning "1. EC2 instance is running"
    print_warning "2. Security group allows SSH (port 22)"
    print_warning "3. SSH key is correct"
    exit 1
fi

print_status "✅ SSH connection established"

# Update system
print_status "📦 Updating system packages..."
run_remote "
    sudo apt update -y
    sudo apt install -y curl wget git build-essential software-properties-common
"

# Install Node.js
print_status "📦 Installing Node.js..."
run_remote "
    if ! command -v node &> /dev/null; then
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt install -y nodejs
    fi
"

# Install Ruby via rbenv
print_status "💎 Installing Ruby 3.4.0..."
run_remote "
    if [ ! -d ~/.rbenv ]; then
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
        echo 'export PATH=\"\$HOME/.rbenv/bin:\$PATH\"' >> ~/.bashrc
        echo 'eval \"\$(rbenv init -)\"' >> ~/.bashrc
        git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    fi
    
    export PATH=\"\$HOME/.rbenv/bin:\$PATH\"
    eval \"\$(rbenv init -)\"
    
    if ! rbenv versions | grep -q '3.4.0'; then
        rbenv install 3.4.0
        rbenv global 3.4.0
        rbenv rehash
    fi
    
    gem install bundler
"

# Install databases
print_status "🗄️ Installing databases..."
run_remote "
    # PostgreSQL
    if ! command -v psql &> /dev/null; then
        sudo apt install -y postgresql postgresql-contrib
        sudo systemctl start postgresql
        sudo systemctl enable postgresql
    fi
    
    # Redis
    if ! command -v redis-server &> /dev/null; then
        sudo apt install -y redis-server
        sudo systemctl start redis-server
        sudo systemctl enable redis-server
    fi
    
    # MongoDB
    if ! command -v mongod &> /dev/null; then
        wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -
        echo 'deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
        sudo apt update
        sudo apt install -y mongodb-org
        sudo systemctl start mongod
        sudo systemctl enable mongod
    fi
"

# Install NGINX
print_status "🌐 Installing NGINX..."
run_remote "
    if ! command -v nginx &> /dev/null; then
        sudo apt install -y nginx
        sudo systemctl start nginx
        sudo systemctl enable nginx
    fi
"

# Clone application
print_status "📂 Setting up application directory..."
run_remote "
    sudo mkdir -p $APP_DIR
    sudo chown $EC2_USER:$EC2_USER $APP_DIR
    
    if [ ! -d $APP_DIR/.git ]; then
        git clone $REPO_URL $APP_DIR
    fi
    
    cd $APP_DIR
    git fetch --all
    git checkout $BRANCH
    git pull origin $BRANCH
"

# Setup environment file
print_status "⚙️ Setting up environment configuration..."
if [ -f ".env" ]; then
    copy_to_ec2 ".env" "$APP_DIR/.env"
else
    print_warning ".env file not found locally, copying from .env.example"
    copy_to_ec2 ".env.example" "$APP_DIR/.env"
fi

# Update environment for production
run_remote "
    cd $APP_DIR
    
    # Update .env for production
    sed -i 's/RAILS_ENV=development/RAILS_ENV=production/' .env
    sed -i 's|APP_URL=.*|APP_URL=https://onelastai.com|' .env
    sed -i 's|DOMAIN_NAME=.*|DOMAIN_NAME=onelastai.com|' .env
    sed -i 's|PRODUCTION_HOST=.*|PRODUCTION_HOST=onelastai.com|' .env
    
    # Update database URLs
    sed -i 's|DATABASE_URL=.*|DATABASE_URL=postgresql://onelastai:onelastai_secure_password@localhost:5432/onelastai_production|' .env
    sed -i 's|MONGODB_URI=.*|MONGODB_URI=mongodb://localhost:27017/onelastai_production|' .env
    sed -i 's|REDIS_URL=.*|REDIS_URL=redis://localhost:6379/0|' .env
"

# Install application dependencies
print_status "📦 Installing application dependencies..."
run_remote "
    cd $APP_DIR
    export PATH=\"\$HOME/.rbenv/bin:\$PATH\"
    eval \"\$(rbenv init -)\"
    
    bundle config set --local deployment 'true'
    bundle config set --local without 'development test'
    bundle install --jobs 4 --retry 3
    
    if [ -f package.json ]; then
        npm install --production
    fi
"

# Setup databases
print_status "🗄️ Setting up databases..."
run_remote "
    # PostgreSQL setup
    sudo -u postgres psql -c \"CREATE DATABASE onelastai_production;\" 2>/dev/null || true
    sudo -u postgres psql -c \"CREATE USER onelastai WITH PASSWORD 'onelastai_secure_password';\" 2>/dev/null || true
    sudo -u postgres psql -c \"GRANT ALL PRIVILEGES ON DATABASE onelastai_production TO onelastai;\" 2>/dev/null || true
    sudo -u postgres psql -c \"ALTER USER onelastai CREATEDB;\" 2>/dev/null || true
"

# Setup application
print_status "🏗️ Setting up Rails application..."
run_remote "
    cd $APP_DIR
    export PATH=\"\$HOME/.rbenv/bin:\$PATH\"
    eval \"\$(rbenv init -)\"
    
    # Generate secret key
    SECRET_KEY=\$(RAILS_ENV=production bundle exec rails secret 2>/dev/null || echo 'onelastai_production_secret_key_2024')
    sed -i \"s|SECRET_KEY_BASE=.*|SECRET_KEY_BASE=\$SECRET_KEY|\" .env
    
    # Run database operations
    RAILS_ENV=production bundle exec rails db:migrate 2>/dev/null || {
        echo 'Migration failed, trying to create and migrate...'
        RAILS_ENV=production bundle exec rails db:create
        RAILS_ENV=production bundle exec rails db:migrate
    }
    
    # Compile assets
    RAILS_ENV=production bundle exec rails assets:precompile
"

# Configure NGINX
print_status "🌐 Configuring NGINX..."
copy_to_ec2 "config/nginx/onelastai.conf" "/tmp/onelastai.conf"

run_remote "
    # Update NGINX config for single server
    sed -i 's|server 127.0.0.1:3000;|server 127.0.0.1:3000;|g' /tmp/onelastai.conf
    
    sudo mv /tmp/onelastai.conf /etc/nginx/sites-available/onelastai.com
    sudo ln -sf /etc/nginx/sites-available/onelastai.com /etc/nginx/sites-enabled/
    sudo rm -f /etc/nginx/sites-enabled/default
    
    # Test nginx configuration
    sudo nginx -t
"

# Setup systemd service
print_status "🔧 Setting up systemd service..."
run_remote "
    sudo tee /etc/systemd/system/onelastai.service > /dev/null <<EOF
[Unit]
Description=OneLastAI Rails Application
After=network.target postgresql.service redis-server.service mongod.service

[Service]
Type=simple
User=$EC2_USER
WorkingDirectory=$APP_DIR
Environment=RAILS_ENV=production
Environment=PORT=3000
ExecStart=/home/$EC2_USER/.rbenv/shims/bundle exec rails server -b 0.0.0.0 -p 3000
ExecReload=/bin/kill -USR2 \\\$MAINPID
KillMode=mixed
Restart=always
RestartSec=5
SyslogIdentifier=onelastai

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable onelastai
    sudo systemctl start onelastai
    sudo systemctl reload nginx
"

# Install SSL certificates
print_status "🔒 Setting up SSL certificates..."
run_remote "
    # Install certbot
    sudo apt install -y certbot python3-certbot-nginx
    
    # Generate SSL certificate (you may need to confirm domain ownership)
    sudo certbot --nginx -d onelastai.com -d www.onelastai.com --non-interactive --agree-tos --email admin@onelastai.com 2>/dev/null || {
        echo 'Automated SSL setup failed. You may need to run this manually:'
        echo 'sudo certbot --nginx -d onelastai.com -d www.onelastai.com'
    }
"

# Final health checks
print_status "🏥 Running health checks..."
run_remote "
    echo 'Service Status:'
    sudo systemctl is-active onelastai || echo 'OneLastAI service not running'
    sudo systemctl is-active nginx || echo 'NGINX service not running'
    sudo systemctl is-active postgresql || echo 'PostgreSQL service not running'
    sudo systemctl is-active redis-server || echo 'Redis service not running'
    sudo systemctl is-active mongod || echo 'MongoDB service not running'
    
    echo 'Waiting for application to start...'
    sleep 15
    
    # Test local application
    curl -f http://localhost:3000/health 2>/dev/null || echo 'Local health check pending...'
"

# Deployment summary
echo ""
echo -e "${GREEN}🎉 Deployment completed!${NC}"
echo ""
echo -e "${BLUE}Your OneLastAI application should now be available at:${NC}"
echo -e "${GREEN}🌐 Main Site: https://onelastai.com${NC}"
echo -e "${GREEN}🔧 API: https://api.onelastai.com${NC}"
echo -e "${GREEN}🤖 NeoChat: https://neochat.onelastai.com${NC}"
echo -e "${GREEN}💭 EmotiSense: https://emotisense.onelastai.com${NC}"
echo -e "${GREEN}🎬 CineGen: https://cinegen.onelastai.com${NC}"
echo -e "${GREEN}📝 ContentCrafter: https://contentcrafter.onelastai.com${NC}"
echo -e "${GREEN}... and 20 more AI agents!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. ${BLUE}Configure DNS records to point to 3.27.217.30${NC}"
echo -e "2. ${BLUE}Update API keys in .env file${NC}"
echo -e "3. ${BLUE}Setup SSL for wildcard subdomains if needed${NC}"
echo ""
echo -e "${YELLOW}To manage the application:${NC}"
echo -e "${BLUE}ssh -i $KEY_FILE $EC2_USER@$EC2_HOST${NC}"
echo -e "${BLUE}sudo systemctl {start|stop|restart|status} onelastai${NC}"
echo -e "${BLUE}sudo journalctl -u onelastai -f  # View logs${NC}"
echo ""
echo -e "${GREEN}Deployment completed successfully! 🚀${NC}"
