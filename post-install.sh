#!/bin/bash
# CosmicOS Post-Deployment Script

echo "🚀 Initializing CosmicOS Deployment..."

# 1. Update and Link GitHub
git remote add origin https://github.com/your-username/cosmicos.git
git config --global credential.helper store
# Note: Use your saved token for the first push/pull

# 2. Check for ZFS / Local SSD Storage
if zfs list | grep -q "tank-1"; then
    echo "✅ tank-1 detected. Ensuring AI storage paths are correct."
else
    echo "⚠️ tank-1 not found. Check physical disk assignment."
fi

# 3. Refresh AI Handshake (CORS Fix)
echo "🔧 Applying CORS Fix for Open WebUI..."
cat <<EOF > /etc/systemd/system/ollama.service.d/override.conf
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
Environment="OLLAMA_ORIGINS=*"
EOF

systemctl daemon-reload
systemctl restart ollama

echo "✅ CosmicOS is synced and ready."
