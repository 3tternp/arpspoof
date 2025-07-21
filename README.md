# arpspoof

This is a simple bash script to perform arp spoofing attack.This script takes user input and give the output of the attack. The crafted packets are sniffed using driftnet(packet sniffing tool found inbuilt in kali linux or other Pentesting Linux Distribution). Thanks to Nishan8583 for helping me to modifying the scrpt and look attractive 

# changelog 
v2.0.0 – 2025-07-21

🎉 Major release with full attack menu interface

✅ Added

1. Interactive menu-based interface for choosing attack modes

ARP Spoofing + Driftnet

ARP Spoofing + SSLStrip

Full Attack (ARP + Driftnet + SSLStrip)

2. Modular function design for easier customization and maintenance

Logging support for:

ARP spoofing logs (2 directions)

Driftnet output

SSLStrip credentials

xterm integration to run SSLStrip in a separate terminal

Root privilege check before script execution

iptables HTTP redirection rule for SSLStrip

Auto-installation of required tools (arpspoof, driftnet, sslstrip, xterm) via available package manager

Graceful cleanup on CTRL+C: kills background processes, flushes iptables, disables IP forwarding
