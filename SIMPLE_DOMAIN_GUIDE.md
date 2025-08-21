# 🚀 SIMPLE DOMAIN SETUP: Hostinger → Route 53 → EC2
# ================================================

## 🎯 GOAL: onelastai.com → EC2 (122.248.242.170) → Rails App

## 📋 STEP 1: HOSTINGER DOMAIN PANEL
1. Login to **Hostinger**
2. Go to **Domains** → **onelastai.com** → **DNS/Nameservers**
3. Change nameservers to Route 53 (we'll get these next)

## 📋 STEP 2: AWS ROUTE 53 SETUP
1. AWS Console → **Route 53** → **Hosted Zones**
2. **Create Hosted Zone** for `onelastai.com`
3. **Copy the 4 nameservers** (like ns-xxx.awsdns-xxx.com)
4. **Go back to Hostinger** → paste these nameservers

## 📋 STEP 3: CREATE DNS RECORDS IN ROUTE 53
```
Record Type: A
Name: onelastai.com
Value: 122.248.242.170
TTL: 300

Record Type: A  
Name: www.onelastai.com
Value: 122.248.242.170
TTL: 300

Record Type: CNAME
Name: *.onelastai.com  
Value: onelastai.com
TTL: 300
```

## 📋 STEP 4: SIMPLE NGINX CONFIG ON EC2
- Deploy simple nginx config (no SSL complexity)
- Direct proxy to Rails app on port 3000
- Works immediately after DNS propagation

## ⚡ EXECUTION TIME: 5-10 minutes
## 🎯 RESULT: http://onelastai.com → Working Rails app

## 💡 WHY THIS IS BETTER:
- No Cloudflare complications
- No complex SSL setup initially  
- Direct AWS Route 53 (fast, reliable)
- Can add SSL later with Let's Encrypt
- Simple troubleshooting
