#!/bin/bash

echo "=== Wrec Pi Ground Station ==="

# Ensure scripts are executable
chmod +x setup_ap.sh start_server.sh

# Start Wi-Fi AP
./setup_ap.sh

# Start web server
./start_server.sh
