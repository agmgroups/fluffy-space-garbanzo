# OneLastAI AWS EC2 Deployment Guide

## 🚀 **AWS EC2 Instance Deployment for onelastai.com**

**EC2 Instance Details:**
- **Host**: `ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com`
- **Region**: `ap-southeast-2` (Asia Pacific - Sydney)
- **Key**: `roombreaker.pem`
- **User**: `ubuntu`

## 📋 **Pre-Deployment Checklist**

### 1. **Domain Configuration**
Configure your DNS to point to the EC2 instance:

```bash
# Add these DNS records in your domain provider:
A    onelastai.com                → 3.27.217.30
A    www.onelastai.com           → 3.27.217.30
A    api.onelastai.com           → 3.27.217.30
A    *.onelastai.com             → 3.27.217.30  # Wildcard for all agent subdomains
```

### 2. **Security Group Configuration**
Ensure your EC2 security group allows:
- **Port 80** (HTTP) - from 0.0.0.0/0
- **Port 443** (HTTPS) - from 0.0.0.0/0  
- **Port 22** (SSH) - from your IP
- **Port 3000** (Rails) - from localhost only (for testing)

## 🔧 **Automated Deployment Script**

Create this deployment script on your local machine:

```bash
#!/bin/bash
# deploy-to-ec2.sh - OneLastAI EC2 Deployment Script

set -e

# Configuration
EC2_HOST="ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com"
EC2_USER="ubuntu"
KEY_FILE="roombreaker.pem"
DOMAIN="onelastai.com"
APP_DIR="/var/www/onelastai"
REPO_URL="https://github.com/1-ManArmy/fluffy-space-garbanzo.git"
BRANCH="domain-onelastai-setup"

echo "🚀 Starting OneLastAI deployment to EC2..."

# Function to run commands on EC2
run_remote() {
    ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no "$EC2_USER@$EC2_HOST" "$1"
}

# Function to copy files to EC2
copy_to_ec2() {
    scp -i "$KEY_FILE" -o StrictHostKeyChecking=no "$1" "$EC2_USER@$EC2_HOST:$2"
}

echo "📦 Step 1: Updating system and installing dependencies..."
run_remote "
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y curl wget git build-essential
    sudo apt install -y postgresql postgresql-contrib
    sudo apt install -y redis-server
    sudo apt install -y nginx
    sudo apt install -y nodejs npm
    sudo apt install -y imagemagick libvips42
"

echo "💎 Step 2: Installing Ruby..."
run_remote "
    # Install rbenv
    if [ ! -d ~/.rbenv ]; then
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
        echo 'export PATH=\"\$HOME/.rbenv/bin:\$PATH\"' >> ~/.bashrc
        echo 'eval \"\$(rbenv init -)\"' >> ~/.bashrc
        git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    fi
    export PATH=\"\$HOME/.rbenv/bin:\$PATH\"
    eval \"\$(rbenv init -)\"
    
    # Install Ruby 3.4.0
    if ! rbenv versions | grep -q '3.4.0'; then
        rbenv install 3.4.0
        rbenv global 3.4.0
    fi
    
    # Install bundler
    gem install bundler
"

echo "🗄️ Step 3: Setting up MongoDB..."
run_remote "
    # Install MongoDB
    if ! command -v mongod &> /dev/null; then
        wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -
        echo 'deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
        sudo apt update
        sudo apt install -y mongodb-org
        sudo systemctl start mongod
        sudo systemctl enable mongod
    fi
"

echo "🔄 Step 4: Cloning application repository..."
run_remote "
    # Create app directory
    sudo mkdir -p $APP_DIR
    sudo chown $EC2_USER:$EC2_USER $APP_DIR
    
    # Clone repository
    if [ ! -d $APP_DIR/.git ]; then
        git clone $REPO_URL $APP_DIR
    fi
    
    cd $APP_DIR
    git checkout $BRANCH
    git pull origin $BRANCH
"

echo "💎 Step 5: Installing application dependencies..."
run_remote "
    cd $APP_DIR
    export PATH=\"\$HOME/.rbenv/bin:\$PATH\"
    eval \"\$(rbenv init -)\"
    
    # Install gems
    bundle config set --local deployment 'true'
    bundle config set --local without 'development test'
    bundle install
    
    # Install npm packages if package.json exists
    if [ -f package.json ]; then
        npm install --production
    fi
"

echo "🗄️ Step 6: Setting up databases..."
run_remote "
    # PostgreSQL setup
    sudo -u postgres psql -c \"CREATE DATABASE onelastai_production;\" || true
    sudo -u postgres psql -c \"CREATE USER onelastai WITH PASSWORD 'onelastai_secure_password';\" || true
    sudo -u postgres psql -c \"GRANT ALL PRIVILEGES ON DATABASE onelastai_production TO onelastai;\" || true
    
    # MongoDB setup
    mongosh --eval \"
        use onelastai_production;
        db.createUser({
            user: 'onelastai',
            pwd: 'onelastai_mongo_password',
            roles: [{role: 'readWrite', db: 'onelastai_production'}]
        });
    \" || true
"

echo "⚙️ Step 7: Configuring environment..."
# Copy the .env file
copy_to_ec2 ".env" "$APP_DIR/.env"

run_remote "
    cd $APP_DIR
    
    # Update .env for production
    sed -i 's/RAILS_ENV=development/RAILS_ENV=production/' .env
    sed -i 's/APP_URL=.*/APP_URL=https:\/\/onelastai.com/' .env
    sed -i 's/DOMAIN_NAME=.*/DOMAIN_NAME=onelastai.com/' .env
    
    # Generate secret keys if needed
    export PATH=\"\$HOME/.rbenv/bin:\$PATH\"
    eval \"\$(rbenv init -)\"
    
    SECRET_KEY=\$(RAILS_ENV=production bundle exec rails secret)
    sed -i \"s/SECRET_KEY_BASE=.*/SECRET_KEY_BASE=\$SECRET_KEY/\" .env
"

echo "🏗️ Step 8: Setting up application..."
run_remote "
    cd $APP_DIR
    export PATH=\"\$HOME/.rbenv/bin:\$PATH\"
    eval \"\$(rbenv init -)\"
    
    # Run database migrations
    RAILS_ENV=production bundle exec rails db:create db:migrate
    
    # Compile assets
    RAILS_ENV=production bundle exec rails assets:precompile
    
    # Seed database (optional)
    # RAILS_ENV=production bundle exec rails db:seed
"

echo "🌐 Step 9: Configuring NGINX..."
copy_to_ec2 "config/nginx/onelastai.conf" "/tmp/onelastai.conf"

run_remote "
    sudo mv /tmp/onelastai.conf /etc/nginx/sites-available/onelastai.com
    sudo ln -sf /etc/nginx/sites-available/onelastai.com /etc/nginx/sites-enabled/
    sudo rm -f /etc/nginx/sites-enabled/default
    
    # Test nginx configuration
    sudo nginx -t
"

echo "🔒 Step 10: Setting up SSL certificates..."
run_remote "
    # Install certbot
    sudo apt install -y certbot python3-certbot-nginx
    
    # Generate SSL certificates
    sudo certbot --nginx -d onelastai.com -d www.onelastai.com --non-interactive --agree-tos --email admin@onelastai.com
    
    # Generate wildcard certificate for subdomains
    echo 'Setting up wildcard certificate...'
    echo 'You may need to manually add DNS TXT record for verification'
    # sudo certbot certonly --manual --preferred-challenges=dns -d *.onelastai.com
"

echo "🔧 Step 11: Setting up systemd service..."
run_remote "
    # Create systemd service
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

    # Enable and start services
    sudo systemctl daemon-reload
    sudo systemctl enable onelastai
    sudo systemctl start onelastai
    sudo systemctl restart nginx
"

echo "✅ Step 12: Running health checks..."
run_remote "
    # Check service status
    sudo systemctl status onelastai --no-pager -l
    sudo systemctl status nginx --no-pager -l
    
    # Test application
    sleep 10
    curl -f http://localhost:3000/health || echo 'Health check will be available once app starts'
"

echo "🎉 Deployment completed!"
echo ""
echo "Your OneLastAI application should now be available at:"
echo "🌐 Main Site: https://onelastai.com"
echo "🔧 API: https://api.onelastai.com"
echo "🤖 Agents: https://neochat.onelastai.com (and 23 others)"
echo ""
echo "To check logs:"
echo "  ssh -i $KEY_FILE $EC2_USER@$EC2_HOST"
echo "  sudo journalctl -u onelastai -f"
echo ""
echo "To manage the application:"
echo "  sudo systemctl {start|stop|restart|status} onelastai"
```

## 🚀 **Quick Deployment Steps**

### 1. **Prepare your local environment:**
```bash
# Make sure you have the SSH key
chmod 400 roombreaker.pem

# Save the deployment script above as deploy-to-ec2.sh
chmod +x deploy-to-ec2.sh
```

### 2. **Run the deployment:**
```bash
./deploy-to-ec2.sh
```

### 3. **Manual SSL setup for subdomains (if needed):**
```bash
# SSH into your server
ssh -i "roombreaker.pem" ubuntu@ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com

# Generate wildcard certificate
sudo certbot certonly --manual --preferred-challenges=dns -d "*.onelastai.com"
# Follow the instructions to add DNS TXT record
```

## 🔧 **Manual Deployment (Alternative)**

If you prefer manual deployment:

```bash
# 1. SSH into the server
ssh -i "roombreaker.pem" ubuntu@ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com

# 2. Update system
sudo apt update && sudo apt upgrade -y

# 3. Install dependencies
sudo apt install -y ruby-full nodejs npm postgresql redis-server nginx mongodb-org

# 4. Clone repository
git clone https://github.com/1-ManArmy/fluffy-space-garbanzo.git /var/www/onelastai
cd /var/www/onelastai
git checkout domain-onelastai-setup

# 5. Run the deployment script on the server
chmod +x deploy_onelastai.sh
./deploy_onelastai.sh --letsencrypt --seed
```

## 🏥 **Health Checks & Monitoring**

After deployment, verify everything is working:

```bash
# Check service status
sudo systemctl status onelastai nginx postgresql redis-server mongod

# Check application logs
sudo journalctl -u onelastai -f

# Test endpoints
curl https://onelastai.com/health
curl https://api.onelastai.com/health
curl https://neochat.onelastai.com/health
```

## 🔧 **Troubleshooting**

### Common issues and solutions:

1. **SSL Certificate Issues:**
   ```bash
   sudo certbot --nginx -d onelastai.com -d www.onelastai.com
   ```

2. **Database Connection Issues:**
   ```bash
   sudo systemctl status postgresql
   sudo -u postgres psql -c "\l"  # List databases
   ```

3. **Application Won't Start:**
   ```bash
   cd /var/www/onelastai
   RAILS_ENV=production bundle exec rails console
   ```

4. **Check NGINX Configuration:**
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

## 📊 **Post-Deployment Configuration**

1. **Setup monitoring dashboard**: Access `https://monitoring.onelastai.com`
2. **Configure API keys**: Update `.env` with actual API keys for AI services
3. **Setup backups**: Configure automated database backups
4. **Monitor logs**: Setup log rotation and monitoring

---

Your OneLastAI platform is now ready for production deployment on AWS EC2! 🚀
