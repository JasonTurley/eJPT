#!/bin/bash

# Automates host discovery and port scanning - essentially a wrapper for
# fping and nmap.

TARGET_NETWORK=$1
HOST_FILE="alive_hosts.txt"
OUT_FILE="nmap_scan.txt"

print_usage()
{
	echo "Usage: $0 <TARGET_NETWORK range>"
}

scan()
{
	echo "++ starting fping scan ++"
	fping -a -g $TARGET_NETWORK 2>/dev/null | tee $HOST_FILE;
	
	echo ""

	echo "++ starting nmap scan ++"
	sudo nmap -p- -sV -A -Pn -T4 -iL $HOST_FILE -oN $OUT_FILE;
}

if [ -z "$TARGET_NETWORK" ]; then
	print_usage
	exit 1
fi

scan
