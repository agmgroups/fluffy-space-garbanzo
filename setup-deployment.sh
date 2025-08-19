#!/bin/bash

# OneLastAI Setup Helper Script
# Run this before deployment to set up SSH key and environment

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 OneLastAI Setup Helper${NC}"
echo -e "${BLUE}Preparing for EC2 deployment...${NC}"
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

# Check if we're in the right directory
if [ ! -f "deploy-to-ec2.sh" ]; then
    print_error "Please run this script from the fluffy-space-garbanzo directory"
    exit 1
fi

print_status "Setting up OneLastAI deployment environment..."

# 1. SSH Key Setup
echo ""
echo -e "${YELLOW}📁 SSH Key Setup${NC}"
if [ -f "roombreaker.pem" ]; then
    print_status "SSH key found: roombreaker.pem"
    chmod 400 roombreaker.pem
    print_status "SSH key permissions updated"
else
    print_warning "SSH key 'roombreaker.pem' not found"
    echo "Please copy your SSH key to this directory:"
    echo "cp /path/to/your/roombreaker.pem ."
    echo "Or upload it through VS Code file browser"
    echo ""
    read -p "Press Enter when you've added the SSH key..."
    
    if [ -f "roombreaker.pem" ]; then
        chmod 400 roombreaker.pem
        print_status "SSH key permissions updated"
    else
        print_error "SSH key still not found. Please add it before proceeding."
        exit 1
    fi
fi

# 2. Environment Configuration
echo ""
echo -e "${YELLOW}⚙️  Environment Configuration${NC}"
if [ ! -f ".env" ]; then
    print_warning ".env file not found, copying from .env.example"
    if [ -f ".env.example" ]; then
        cp .env.example .env
        print_status "Created .env from .env.example"
    else
        print_error ".env.example not found. Please create environment file."
        exit 1
    fi
fi

# 3. Update .env with production settings
print_status "Updating .env with production settings..."

# Update domain settings
sed -i 's/RAILS_ENV=development/RAILS_ENV=production/' .env 2>/dev/null || true
sed -i 's|APP_URL=.*|APP_URL=https://onelastai.com|' .env 2>/dev/null || true
sed -i 's|DOMAIN_NAME=.*|DOMAIN_NAME=onelastai.com|' .env 2>/dev/null || true
sed -i 's|PRODUCTION_HOST=.*|PRODUCTION_HOST=onelastai.com|' .env 2>/dev/null || true

print_status "Environment configuration updated"

# 4. Generate deployment summary
echo ""
echo -e "${YELLOW}📋 Deployment Summary${NC}"
print_status "Domain: onelastai.com"
print_status "Total AI Agents: 27"
print_status "EC2 Instance: ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com"
print_status "Deployment Branch: domain-onelastai-setup"

# 5. Show all 27 AI agents
echo ""
echo -e "${YELLOW}🤖 All 27 AI Agents Ready for Deployment:${NC}"
echo ""
echo -e "${BLUE}Communication & Chat (5):${NC}"
echo "• NeoChat (neochat.onelastai.com)"
echo "• EmotiSense (emotisense.onelastai.com)" 
echo "• Girlfriend (girlfriend.onelastai.com)"
echo "• CareBot (carebot.onelastai.com)"
echo "• CallGhost (callghost.onelastai.com)"
echo ""
echo -e "${BLUE}Creative & Content (5):${NC}"
echo "• CineGen (cinegen.onelastai.com)"
echo "• ContentCrafter (contentcrafter.onelastai.com)"
echo "• DreamWeaver (dreamweaver.onelastai.com)"
echo "• AIBlogster (aiblogster.onelastai.com)"
echo "• VocaMind (vocamind.onelastai.com)"
echo ""
echo -e "${BLUE}Technical & Development (5):${NC}"
echo "• CodeMaster (codemaster.onelastai.com)"
echo "• ConfigAI (configai.onelastai.com)"
echo "• DNAForge (dnaforge.onelastai.com)"
echo "• NetScope (netscope.onelastai.com)"
echo "• LabX (labx.onelastai.com)"
echo ""
echo -e "${BLUE}Data & Analytics (5):${NC}"
echo "• DataVision (datavision.onelastai.com)"
echo "• DataSphere (datasphere.onelastai.com)"
echo "• Reportly (reportly.onelastai.com)"
echo "• SpyLens (spylens.onelastai.com)"
echo "• TradeSage (tradesage.onelastai.com)"
echo ""
echo -e "${BLUE}Knowledge & Productivity (7):${NC}"
echo "• InfoSeek (infoseek.onelastai.com)"
echo "• DocuMind (documind.onelastai.com)"
echo "• Memora (memora.onelastai.com)"
echo "• IdeaForge (ideaforge.onelastai.com)"
echo "• TaskMaster (taskmaster.onelastai.com)"
echo "• AuthWise (authwise.onelastai.com)"
echo "• Awards (awards.onelastai.com)"
echo "• PersonaX (personax.onelastai.com)"

# 6. Pre-deployment checklist
echo ""
echo -e "${YELLOW}✅ Pre-Deployment Checklist${NC}"
echo ""
echo "Before running ./deploy-to-ec2.sh, ensure:"
echo ""
echo "1. 📡 DNS Configuration:"
echo "   - Point onelastai.com to 3.27.217.30"
echo "   - Point *.onelastai.com to 3.27.217.30"
echo ""
echo "2. 🔐 Security Group (AWS Console):"
echo "   - Allow SSH (port 22) from your IP"
echo "   - Allow HTTP (port 80) from anywhere"
echo "   - Allow HTTPS (port 443) from anywhere"
echo ""
echo "3. 🔑 API Keys (Update .env after deployment):"
echo "   - OPENAI_API_KEY"
echo "   - ANTHROPIC_API_KEY"
echo "   - GOOGLE_AI_API_KEY"
echo "   - STABILITY_API_KEY"
echo "   - ELEVENLABS_API_KEY"
echo "   - And others as needed"
echo ""

# 7. Test SSH connection
echo -e "${YELLOW}🔌 Testing SSH Connection${NC}"
if ssh -i roombreaker.pem -o ConnectTimeout=5 -o StrictHostKeyChecking=no ubuntu@ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com "echo 'SSH test successful'" 2>/dev/null; then
    print_status "✅ SSH connection to EC2 instance successful!"
else
    print_warning "⚠️  SSH connection test failed. Check:"
    echo "   - EC2 instance is running"
    echo "   - Security group allows SSH from your IP"
    echo "   - SSH key is correct"
fi

echo ""
echo -e "${GREEN}🎉 Setup completed!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Configure DNS records"
echo "2. Run: ${BLUE}./deploy-to-ec2.sh${NC}"
echo "3. Update API keys in production"
echo "4. Test all 27 AI agents"
echo ""
echo -e "${GREEN}Ready to deploy OneLastAI to production! 🚀${NC}"
