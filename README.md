# arpspoof

This is a simple bash script to perform arp spoofing attack.This script takes user input and give the output of the attack. The crafted packets are sniffed using driftnet(packet sniffing tool found inbuilt in kali linux or other Pentesting Linux Distribution). Thanks to Nishan8583 for helping me to modifying the scrpt and look attractive 
# changelog 
🔥 New Features:
Each tool installs separately if not found (arpspoof or driftnet).

trap cleanup INT cleanly stops arpspoof processes and resets IP forwarding on Ctrl+C.

Good user feedback on each step.

Cross-distro support (apt, yum, pacman).

