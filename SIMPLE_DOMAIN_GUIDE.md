# 🚀 SIMPLE DOMAIN SETUP: Hostinger → Render
# ==========================================

## 🎯 GOAL: onelastai.com → Render → Rails App

## 📋 STEP 1: HOSTINGER DOMAIN PANEL
1. Login to **Hostinger**
2. Go to **Domains** → **onelastai.com** → **DNS Zone**
3. Update DNS records to point to Render

## 📋 STEP 2: DNS RECORDS IN HOSTINGER
1. Delete existing A records
2. Add CNAME records pointing to Render
3. Wait for DNS propagation (up to 24 hours)

## 📋 STEP 3: CREATE DNS RECORDS
```
Record Type: CNAME
Name: @
Target: onelastai.onrender.com
TTL: 300

Record Type: CNAME  
Name: www
Target: onelastai.onrender.com
TTL: 300

Record Type: CNAME
Name: *
Target: onelastai.onrender.com
TTL: 300
```

## 📋 STEP 4: RENDER CUSTOM DOMAIN SETUP
- Add onelastai.com in Render dashboard
- Render automatically configures SSL
- Domain verification happens via DNS

## ⚡ EXECUTION TIME: 5-10 minutes
## 🎯 RESULT: https://onelastai.com → Working Rails app

## 💡 WHY THIS IS BETTER:
- No server management needed
- Automatic SSL certificates
- Direct DNS pointing (fast, reliable)
- Built-in scaling and monitoring
- Simple troubleshooting
