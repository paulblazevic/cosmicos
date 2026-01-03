#!/bin/bash
# CosmicOS Post-Deployment Script - GPU & Cloud Aware

echo "🚀 Initializing CosmicOS Deployment on Debian 13 (PVE 9.1)..."

# 1. GPU Detection Logic
if lspci | grep -qi nvidia; then
    echo "🏎️ NVIDIA GPU Detected (Quadro/Mobile). Installing Drivers..."
    # Standard drivers for Debian 13 / PVE 9
    apt update && apt install -y nvidia-driver firmware-misc-nonfree
else
    echo "☁️ No GPU detected. Optimizing for Cloud/VPS (Headless mode)."
fi

# 2. GitHub Handshake
# Ensuring we are in the right spot
cd /opt/cosmicos/scripts
git pull origin main

# 3. AI Service Optimization (CORS Fix)
echo "🔧 Configuring Ollama for Cosmic Energy Research..."
mkdir -p /etc/systemd/system/ollama.service.d
cat <<OVERRIDE > /etc/systemd/system/ollama.service.d/override.conf
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
Environment="OLLAMA_ORIGINS=*"
OVERRIDE

systemctl daemon-reload
systemctl restart ollama 2>/dev/null || echo "Ollama not installed yet, skipping restart."

echo "✅ CosmicOS Sync Complete."
