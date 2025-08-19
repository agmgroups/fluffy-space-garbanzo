# Quick EC2 Deployment Guide

## Prerequisites

1. **SSH Key**: Ensure `roombreaker.pem` is in your current directory
2. **DNS**: Configure DNS records to point `onelastai.com` and `*.onelastai.com` to `3.27.217.30`
3. **Security Group**: EC2 security group should allow:
   - SSH (port 22) from your IP
   - HTTP (port 80) from anywhere
   - HTTPS (port 443) from anywhere

## DNS Configuration

Before running the deployment, set up these DNS records:

```
Type    Name                    Value           TTL
A       onelastai.com          3.27.217.30     300
A       www.onelastai.com      3.27.217.30     300
A       *.onelastai.com        3.27.217.30     300
```

## Deployment Steps

1. **Place SSH key in current directory**:
   ```bash
   # Make sure roombreaker.pem is in the current directory
   ls -la roombreaker.pem
   chmod 400 roombreaker.pem
   ```

2. **Run deployment script**:
   ```bash
   ./deploy-to-ec2.sh
   ```

3. **Monitor deployment**:
   The script will show colored output for each step. Green = success, Yellow = warning, Red = error.

## What the Script Does

- ✅ Tests SSH connectivity
- ✅ Installs system dependencies (Node.js, Ruby 3.4.0, databases)
- ✅ Sets up PostgreSQL, MongoDB, and Redis
- ✅ Clones your application from the `domain-onelastai-setup` branch
- ✅ Installs application dependencies
- ✅ Configures production environment
- ✅ Sets up database with migrations
- ✅ Compiles assets
- ✅ Configures NGINX reverse proxy
- ✅ Creates systemd service for auto-startup
- ✅ Attempts SSL certificate setup with Let's Encrypt
- ✅ Runs health checks

## After Deployment

### Application URLs
- **Main Site**: https://onelastai.com
- **API**: https://api.onelastai.com
- **AI Agents**: https://{agent}.onelastai.com

### Management Commands

```bash
# SSH into the server
ssh -i roombreaker.pem ubuntu@ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com

# Service management
sudo systemctl status onelastai    # Check status
sudo systemctl restart onelastai   # Restart app
sudo systemctl stop onelastai      # Stop app
sudo systemctl start onelastai     # Start app

# View logs
sudo journalctl -u onelastai -f    # Follow live logs
sudo journalctl -u onelastai -n 50 # Last 50 lines

# NGINX management
sudo systemctl reload nginx        # Reload config
sudo nginx -t                      # Test config
```

### Configuration Files on Server

- **Application**: `/var/www/onelastai/`
- **Environment**: `/var/www/onelastai/.env`
- **NGINX Config**: `/etc/nginx/sites-available/onelastai.com`
- **Service**: `/etc/systemd/system/onelastai.service`
- **SSL Certificates**: `/etc/letsencrypt/live/onelastai.com/`

### Environment Variables to Update

After deployment, SSH into the server and update these in `.env`:

```bash
cd /var/www/onelastai
sudo nano .env

# Update these values:
OPENAI_API_KEY=your_actual_openai_key
ANTHROPIC_API_KEY=your_actual_anthropic_key
GOOGLE_AI_API_KEY=your_actual_google_key
SENDGRID_API_KEY=your_actual_sendgrid_key
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key

# Then restart the service
sudo systemctl restart onelastai
```

## Troubleshooting

### If deployment fails:

1. **Check SSH connectivity**:
   ```bash
   ssh -i roombreaker.pem ubuntu@ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com
   ```

2. **Check security group**: Ensure ports 22, 80, 443 are open

3. **Run deployment again**: The script is idempotent and can be run multiple times

### If application doesn't start:

1. **Check logs**:
   ```bash
   sudo journalctl -u onelastai -n 100
   ```

2. **Check database connectivity**:
   ```bash
   sudo -u postgres psql -c "SELECT version();"
   redis-cli ping
   mongosh --eval "db.runCommand({ping: 1})"
   ```

3. **Manual start for debugging**:
   ```bash
   cd /var/www/onelastai
   RAILS_ENV=production bundle exec rails server
   ```

### If SSL setup fails:

1. **Ensure DNS is configured** and propagated (may take up to 48 hours)
2. **Run SSL setup manually**:
   ```bash
   sudo certbot --nginx -d onelastai.com -d www.onelastai.com
   sudo certbot --nginx -d "*.onelastai.com"
   ```

## Next Steps

1. Configure DNS records
2. Run the deployment script
3. Update API keys in production
4. Test all AI agent endpoints
5. Set up monitoring and backups

The deployment should take 10-15 minutes depending on your internet connection and server performance.
