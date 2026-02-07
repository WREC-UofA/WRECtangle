#!/bin/bash

echo "[+] Configuring Wi-Fi access point..."

sudo systemctl stop hostapd
sudo systemctl stop dnsmasq

# Static IP for wlan0
sudo tee /etc/dhcpcd.conf.d/wrec_ap.conf > /dev/null <<EOF
interface wlan0
static ip_address=192.168.50.1/24
nohook wpa_supplicant
EOF

# dnsmasq config
sudo tee /etc/dnsmasq.d/wrec_ap.conf > /dev/null <<EOF
interface=wlan0
dhcp-range=192.168.50.10,192.168.50.100,255.255.255.0,24h
EOF

# hostapd config
sudo tee /etc/hostapd/hostapd.conf > /dev/null <<EOF
interface=wlan0
driver=nl80211
ssid=WrecPiGUI
hw_mode=g
channel=7
auth_algs=1
wpa=2
wpa_passphrase=thewrecpassword
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
EOF

sudo sed -i 's|#DAEMON_CONF=.*|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd

sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq

sudo systemctl start dnsmasq
sudo systemctl start hostapd

echo "[✓] Wi-Fi network WrecPiGUI is up"
