#!/bin/bash

ARCH=$(uname -a)

PPROCSS=$(lscpu | grep "Socket(s)" | awk '{print $2}')

VPROCSS=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

RAMUSE=$(free -h | sed -n '2p' | awk '{print $3 "/" $2}' | tr "i" "b")

RAMPRC=$(free | sed -n '2p' | awk '{printf("%.2f"), $3/$2*100}')

DISK=$(df -h --total | grep total | awk '{print $3 "/" $2 " (" $5 ")"}')

CPU=$(top -bn 1 | sed -n '3p' | cut -d "," -f 4 | awk '{printf("%.1f\n"), 100-$1}')

LSTRBT=$(uptime -s | cut -d ":" -f 1,2)

LVM=$(cat /proc/partitions | grep -c "dm-")

LVMDSP=$(if [ $LVM -eq "0" ]; then echo no; else echo yes; fi)

CONNC=$(ss -t | grep -c "ESTAB")

USERS=$(users | wc -w)

IPADDRS=$(hostname -I)

MACADDRS=$(ip -o link | cut -d " " -f 20 | sed -n '2p')

SUDO=$(journalctl -q _COMM=sudo | grep -c "COMMAND")

wall "	#Architecture: $ARCH
	#CPU physical: $PPROCSS
	#vCPU: $VPROCSS
	#Memory Usage: $RAMUSE ($RAMPRC%)
	#Disk Usage: $DISK
	#CPU load: $CPU%
	#Last boot: $LSTRBT
	#LVM use: $LVMDSP
	#Connections TCP: $CONNC ESTABLISHED
	#User log: $USERS
	#Network: IP $IPADDRS ($MACADDRS)
	#Sudo: $SUDO cmd
"
