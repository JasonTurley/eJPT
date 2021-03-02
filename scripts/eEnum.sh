#!/bin/bash
# A wrapper for fping and nmap to help automate the host enumeration.

TARGET=$1
HOST_FILE="alive_hosts.txt"
OUT_FILE="nmap_scan.txt"

print_usage()
{
	echo "Usage: $0 <TARGET range>"
}

scan()
{
	echo "++ starting fping scan ++"
	fping -a -g $TARGET 2>/dev/null | tee $HOST_FILE;
	
	echo ""

	echo "++ starting nmap scan ++"
	sudo nmap -p- -sV -A -Pn -T4 -iL $HOST_FILE -oN $OUT_FILE;
}

if [ -z "$TARGET" ]; then
	print_usage
	exit 1
fi

scan
