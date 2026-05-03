#!/bin/bash

# --- Блок установки PIN-кода ---
clear
echo "==============================="
echo "   CREATE NEW PIN SETUP"
echo "==============================="
read -s -p "Enter new PIN: " PIN1
echo
read -s -p "Confirm new PIN: " PIN2
echo

if [ "$PIN1" != "$PIN2" ]; then
    echo "PINs do not match. Exiting..."
    exit 1
fi
clear

# --- Блок логина по PIN-коду ---
echo "==============================="
echo "   LOGIN TO SESSION"
echo "==============================="
read -s -p "Enter PIN to Login: " LOGIN_PIN
echo
if [ "$LOGIN_PIN" != "$PIN1" ]; then
    echo "Invalid PIN. Access denied."
    exit 1
fi

# --- Основной скрипт RDP ---
echo -e "123\n123" | sudo passwd $USER > /dev/null 2>&1
rm -rf ngrok ngrok.zip > /dev/null 2>&1

echo "======================="
echo "Download ngrok"
echo "======================="
wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
unzip ngrok.zip > /dev/null 2>&1

read -p "Paste Ngrok Authtoken: " CRP
./ngrok authtoken $CRP
clear

echo "======================="
echo "Choose ngrok region"
echo "======================="
echo "us - United States (Ohio)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"
read -p "Region: " REG

./ngrok tcp --region $REG 3388 &>/dev/null &

echo "===================================="
echo "Install RDP"
echo "===================================="
docker pull danielguerra/ubuntu-xrdp > /dev/null 2>&1
clear

echo "===================================="
echo "Start RDP"
echo "===================================="
echo "Username : ubuntu"
echo "Password : ubuntu"
echo "===================================="
echo -n "RDP Address: "
sleep 8
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo "===================================="
echo "Don't close this tab to keep RDP running"
echo "Wait 2 minutes to finish setup"
echo "===================================="

docker run --rm -p 3388:3389 danielguerra/ubuntu-xrdp:kali
