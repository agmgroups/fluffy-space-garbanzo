#!/bin/bash

echo "🚀 SIMPLE DOMAIN SETUP: Hostinger → Route 53 → EC2"
echo "=================================================="

# Step 1: Get our EC2 IP
EC2_IP="122.248.242.170"
DOMAIN="onelastai.com"

echo "🎯 TARGET: $DOMAIN → $EC2_IP"
echo ""

echo "📋 STEP-BY-STEP SIMPLE SETUP:"
echo "============================="

echo "1️⃣ HOSTINGER DOMAIN SETTINGS:"
echo "   - Login to Hostinger Domain Panel"
echo "   - Go to DNS/Nameservers for onelastai.com"
echo "   - Change nameservers to AWS Route 53:"
echo ""

echo "2️⃣ ROUTE 53 HOSTED ZONE (Create these records):"
echo "   A Record: onelastai.com → $EC2_IP"
echo "   A Record: www.onelastai.com → $EC2_IP"
echo "   CNAME: *.onelastai.com → onelastai.com"
echo ""

echo "3️⃣ EC2 NGINX SIMPLE CONFIG:"
echo "   - No SSL complications"
echo "   - Direct domain pointing"
echo "   - Simple proxy setup"
echo ""

echo "🎯 RESULT: onelastai.com → $EC2_IP:3000 (via Nginx)"
echo ""

echo "⚡ EXECUTING SIMPLE SETUP..."
