module.exports = {
  apps: [{
    name: 'onelastai-production',
    script: 'bundle',
    args: 'exec rails server -b 0.0.0.0 -p 3000 -e production',
    cwd: '/home/ubuntu/fluffy-space-garbanzo',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      RAILS_ENV: 'production',
      PORT: 3000,
      BIND: '0.0.0.0'
    },
    error_file: '/home/ubuntu/fluffy-space-garbanzo/log/pm2-error.log',
    out_file: '/home/ubuntu/fluffy-space-garbanzo/log/pm2-out.log',
    log_file: '/home/ubuntu/fluffy-space-garbanzo/log/pm2-combined.log',
    time: true
  }]
}
