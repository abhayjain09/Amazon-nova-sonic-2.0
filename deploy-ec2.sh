#!/bin/bash

# EC2 Deployment Script for Nova Sonic Application
# Run this script as root or with sudo

set -e

echo "Starting Nova Sonic deployment on EC2..."

# Install Node.js if not present
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
    yum install -y nodejs
fi

# Install Python 3.12 if not present
if ! command -v python3.12 &> /dev/null; then
    echo "Installing Python 3.12..."
    yum install -y python3.12 python3.12-pip python3.12-devel
fi

# Navigate to project directory
cd /home/svc-pcldint/nova-sonic

# Setup Python WebSocket Server
echo "Setting up Python WebSocket server..."
cd python-server
python3.12 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
deactivate
cd ..

# Setup React Client
echo "Setting up React client..."
cd react-client
npm install
npm run build
npm install -g serve
cd ..

# Copy service files
echo "Installing systemd service files..."
cp nova-sonic-websocket.service /etc/systemd/system/
cp nova-sonic-react.service /etc/systemd/system/

# Set proper permissions
chown -R svc-pcldint:svc-pcldint /home/svc-pcldint/nova-sonic

# Reload systemd
systemctl daemon-reload

# Enable services
systemctl enable nova-sonic-websocket.service
systemctl enable nova-sonic-react.service

# Start services
systemctl start nova-sonic-websocket.service
systemctl start nova-sonic-react.service

# Check status
echo ""
echo "Deployment complete! Checking service status..."
echo ""
systemctl status nova-sonic-websocket.service --no-pager
echo ""
systemctl status nova-sonic-react.service --no-pager
echo ""
echo "WebSocket server running on port 8084"
echo "React application running on port 3025"
echo "Access the application at: http://$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4):3025"
