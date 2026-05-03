#!/bin/bash

PIN_FILE=".vnc_pin"

# Проверка наличия сохраненного PIN-кода
if [ ! -f "$PIN_FILE" ]; then
    echo "==============================="
    echo "   CREATE NEW PIN SETUP"
    echo "==============================="
    read -s -p "Create new PIN: " NEW_PIN1
    echo
    read -s -p "Confirm new PIN: " NEW_PIN2
    echo
    if [ "$NEW_PIN1" == "$NEW_PIN2" ]; then
        echo "$NEW_PIN1" > "$PIN_FILE"
        echo "PIN saved successfully!"
        sleep 2
    else
        echo "PINs do not match. Restart script."
        exit 1
    fi
fi

# Экран блокировки (Screen Lock)
clear
echo "==============================="
echo "   SCREEN LOCK - LOGIN"
echo "==============================="
SAVED_PIN=$(cat "$PIN_FILE")
read -s -p "Enter PIN to Login: " LOGIN_INPUT
echo
if [ "$LOGIN_INPUT" != "$SAVED_PIN" ]; then
    echo "Access Denied: Invalid PIN."
    exit 1
fi
clear

# Основная часть установки
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
read -p "Choose region: " REG

./ngrok tcp --region $REG 3388 &>/dev/null &

echo "===================================="
echo "Install RDP (Docker)"
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
sleep 1
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo "===================================="
echo "Don't close this tab to keep RDP running"
echo "Keep support HACKTECHTV CHANNEL thank you"
echo "Wait 2 minute to finish the setup then Run using RDP Address"
echo "===================================="

docker run --rm -p 3388:3389 danielguerra/ubuntu-xrdp:kali
