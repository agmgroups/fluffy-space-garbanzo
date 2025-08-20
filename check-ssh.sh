#!/bin/bash

# Quick SSH key setup for OneLastAI deployment

echo "🔑 OneLastAI SSH Key Setup"
echo "=========================="
echo ""

if [ -f "roombreaker.pem" ]; then
    echo "✅ SSH key found!"
    chmod 400 roombreaker.pem
    echo "✅ Permissions set to 400"
    
    # Test connection
    echo "🔌 Testing SSH connection..."
    if ssh -i roombreaker.pem -o ConnectTimeout=5 -o StrictHostKeyChecking=no ubuntu@ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com "echo 'Connection successful!'" 2>/dev/null; then
        echo "✅ SSH connection works!"
        echo ""
        echo "🚀 Ready to deploy! Run:"
        echo "   ./deploy-to-ec2.sh"
    else
        echo "⚠️  SSH connection failed. Check:"
        echo "   - EC2 instance is running"
        echo "   - Security group allows SSH"
        echo "   - Key is correct"
    fi
else
    echo "❌ SSH key 'roombreaker.pem' not found"
    echo ""
    echo "📁 Please upload your SSH key to this directory:"
    echo "   1. Use VS Code file explorer"
    echo "   2. Drag and drop roombreaker.pem"
    echo "   3. Or copy it from your local machine"
    echo ""
    echo "Then run this script again!"
fi
