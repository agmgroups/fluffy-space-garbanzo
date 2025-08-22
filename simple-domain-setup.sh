#!/bin/bash

echo "🚀 SIMPLE DOMAIN SETUP: Hostinger → Render"
echo "=========================================="

# Step 1: Get our Render deployment
RENDER_URL="onelastai.onrender.com"
DOMAIN="onelastai.com"

echo "🎯 TARGET: $DOMAIN → $RENDER_URL"
echo ""

echo "📋 STEP-BY-STEP SIMPLE SETUP:"
echo "============================="

echo "1️⃣ HOSTINGER DOMAIN SETTINGS:"
echo "   - Login to Hostinger Domain Panel"
echo "   - Go to DNS settings for onelastai.com"
echo "   - Add CNAME record pointing to Render:"
echo ""

echo "2️⃣ DNS RECORDS (Add these in Hostinger):"
echo "   CNAME: onelastai.com → onelastai.onrender.com"
echo "   CNAME: www.onelastai.com → onelastai.onrender.com"
echo "   CNAME: *.onelastai.com → onelastai.onrender.com"
echo ""

echo "3️⃣ RENDER CUSTOM DOMAIN:"
echo "   - Add onelastai.com in Render dashboard"
echo "   - SSL automatically configured"
echo "   - Domain verification via DNS"
echo ""

echo "🎯 RESULT: onelastai.com → Render deployment"
echo ""

echo "⚡ EXECUTING SIMPLE SETUP..."
