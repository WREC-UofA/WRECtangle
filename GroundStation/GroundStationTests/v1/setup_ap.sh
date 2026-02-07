#!/bin/bash

# Setup script for WrecPiGUI Wi-Fi Access Point and hostname

# Update system
apt update
apt upgrade -y

# Install required packages
apt install -y hostapd dnsmasq avahi-daemon python3-flask python3-flask-socketio

# Stop services to configure
systemctl stop hostapd
systemctl stop dnsmasq

# Configure hostapd
tee /etc/hostapd/hostapd.conf > /dev/null <<EOF
interface=wlan0
driver=nl80211
ssid=WrecPiGUI
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=thewrecpassword
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

# Configure dnsmasq
tee /etc/dnsmasq.conf > /dev/null <<EOF
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
EOF

# Configure hostapd to start on boot
sed -i 's|#DAEMON_CONF=""|DAEMON_CONF="/etc/hostapd/hostapd.conf"|g' /etc/default/hostapd

# Enable IP forwarding
if grep -q "^net.ipv4.ip_forward" /etc/sysctl.conf 2>/dev/null; then
    sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf
else
    echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.conf > /dev/null
fi
sysctl -w net.ipv4.ip_forward=1

# Configure wlan0 interface
tee -a /etc/dhcpcd.conf > /dev/null <<EOF
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
EOF

# Start services
systemctl start hostapd
systemctl start dnsmasq
systemctl enable hostapd
systemctl enable dnsmasq
systemctl enable avahi-daemon

# Set hostname
hostname wrecgui
echo wrecgui > /etc/hostname

# Create systemd service for the GUI
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
tee /etc/systemd/system/wrec-gui.service > /dev/null <<EOF
[Unit]
Description=WREC Ground Station GUI
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$DIR
ExecStart=/usr/bin/python3 $DIR/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable wrec-gui
systemctl start wrec-gui

echo "Wi-Fi AP setup complete. Reboot to apply hostname changes."