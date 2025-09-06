#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Railway CLI deploy helper"

if ! command -v railway >/dev/null 2>&1; then
	echo "Installing Railway CLI..."
	curl -fsSL https://railway.app/install.sh | bash
	export PATH="$HOME/.railway/bin:$PATH"
fi

echo "Ensuring login (this may open a browser)..."
railway login || true

PROJECT_NAME="onelastai"
SERVICE_NAME="web"

echo "Linking project (creates if missing)..."
railway init --project "$PROJECT_NAME" -y || true

echo "Setting baseline env vars..."
railway variables set \
	RAILS_ENV=production \
	RAILS_LOG_TO_STDOUT=true \
	RAILS_SERVE_STATIC_FILES=true \
	SECRET_KEY_BASE="${SECRET_KEY_BASE:-}" || true

echo "Tip: set MONGODB_URI in Railway dashboard or via CLI:"
echo "  railway variables set MONGODB_URI=your_mongodb_connection_string"

echo "Deploying current directory..."
railway up --service "$SERVICE_NAME"

echo "✅ Deployment triggered. Check status: railway status"
