#!/bin/bash

# Quick SSH test script
echo "🔌 Testing SSH connection with current IP: 23.97.62.118"
echo "================================================="

if ssh -i roombreaker.pem -o ConnectTimeout=10 -o StrictHostKeyChecking=no ubuntu@ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com "echo 'SSH connection successful!'" 2>/dev/null; then
    echo "✅ SSH connection works!"
    echo ""
    echo "🚀 Ready to deploy OneLastAI with all 27 AI agents!"
    echo "Run: ./deploy-to-ec2.sh"
else
    echo "❌ SSH connection still failing"
    echo ""
    echo "Check:"
    echo "1. EC2 instance is running"
    echo "2. Security group allows SSH from 23.97.62.118/32"
    echo "3. Instance is in ap-southeast-2 region"
fi
