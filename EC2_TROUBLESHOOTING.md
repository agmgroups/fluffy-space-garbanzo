# 🔧 EC2 Connection Troubleshooting Guide

## Connection Failed: Timeout Error

The deployment failed because we can't connect to your EC2 instance. Here's how to fix it:

## ✅ **Check These Items:**

### 1. **EC2 Instance Status** 
- Go to AWS Console → EC2 → Instances
- Verify instance `ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com` is **running**
- Check the **Status Checks** are passing

### 2. **Security Group Configuration**
Your security group needs these rules:

| Type  | Protocol | Port | Source    | Description |
|-------|----------|------|-----------|-------------|
| SSH   | TCP      | 22   | 0.0.0.0/0 | SSH access  |
| HTTP  | TCP      | 80   | 0.0.0.0/0 | Web traffic |
| HTTPS | TCP      | 443  | 0.0.0.0/0 | SSL traffic |

### 3. **Network ACLs**
- Check that your VPC's Network ACLs allow inbound/outbound traffic
- Default ACLs usually work fine

### 4. **Key Pair Verification**
- Verify `roombreaker.pem` is the correct key for this instance
- Check the key name in EC2 console matches

## 🔄 **Quick Fixes:**

### Option 1: Restart EC2 Instance
```bash
# In AWS Console:
# 1. Select your instance
# 2. Instance State → Restart
# 3. Wait for it to be "running" 
# 4. Try deployment again
```

### Option 2: Update Security Group
```bash
# In AWS Console:
# 1. Go to EC2 → Security Groups
# 2. Find your instance's security group
# 3. Add inbound rule: SSH (22) from 0.0.0.0/0
# 4. Save rules
```

### Option 3: Check Instance Region
```bash
# Make sure you're looking at the correct region:
# ap-southeast-2 (Asia Pacific - Sydney)
```

## 🧪 **Test Connection Manually**

Once you've checked the above, test with:
```bash
ssh -i roombreaker.pem -v ubuntu@ec2-3-27-217-30.ap-southeast-2.compute.amazonaws.com
```

The `-v` flag will show verbose output to help debug.

## 📞 **When Ready**

After fixing the connection issue, run:
```bash
./deploy-to-ec2.sh
```

---

**Most Common Issue**: Security group not allowing SSH (port 22) from your IP address.

**Quick Check**: Can you see the instance as "running" in the AWS EC2 console?
