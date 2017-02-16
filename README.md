# BURN
An Anti-Forensics Toolkit to clear sensible logfiles on \*nix sistems, inspired by an [EquationGroup](https://github.com/adamcaudill/EquationGroupLeak)'s command which originally made sure "_you've cleaned up any temporary files you've left on the box_".

## USAGE
BURN has several operational modes:
  - `BURN -c 1h` (clear) to delete all log entries older than x hour/minutes
  - `BURN -f` (fake) tamper logs with fake entries. User will be prompted to choose to insert infos e.g. an ip/timespan/other, randomize them or copy older recent log entries and vary them slightly.
  - `BURN -d` (delete) to hard delete log the whole log files and command history of the current user
  - `BURN -b` (burn) securely delete the script and exit. This will also clear the command history.

## TODO
- integration with Defiler's Toolkit (Necrofile and Klismafile, see https://grugq.github.io/docs/phrack-59-06.txt)
- optional logwatch tampering
- optional SNORT tampering
- optional disable of Tripwire (/etc/cron.daily/tripwire-check removed or the whole /var/lib/tripwire/\*.twd db)
- optional AIDE tampering (/var/lib/aide/aide.db)
- ~~*burn BURN recursively*~~

_Log Files in the /var/log Directory:_

|System Logs Name|Filename|Description|
|---|---|---|
|Boot Log|boot.log|Contains messages indicating which systems services have started and shut down successfully and which (if any) have failed to start or stop.|
|Cron Log|cron|Contains status messages from the crond, a daemon that periodically runs scheduled jobs, such as backups and log file rotation.|
|Kernel Startup Log|dmesg|A recording of messages printed by the kernel when the system boots.|
|FTP Log|xferlog|Information about files transferred using the wu-ftpd FTP service.|
|Apache Access Log|httpd/access_log|Logs requests for information from your Apache Web server.|
|Apache Error Log|httpd/error_log|Logs errors encountered from clients trying to access data on your Apache Web server.|
|Mail Log|maillog|Contains information about addresses to which and from which e-mail was sent. Useful for detecting spamming.|
|MySQL Server Log|mysqld.log|Includes information related to activities of the MySQL database server (mysqld).|
|News Log|spooler|Directory containing logs of messages from the Usenet News server, if you are running one.|
|RPM Packages|rpmpkgs|Contains a listing of RPM packages that are installed on your system.|
|Security Log|secure|Records the date, time, and duration of login attempts and sessions.|
|System Log|messages|A general-purpose log file to which many programs record messages.|
|Update Agent Log|up2date|Contains messages resulting from actions by the Red Hat Update Agent.|
|XFree86 Log|XFree86.0.log|Includes messages output by the Xfree86 server.|
|*|gdm/:0.log|Holds messages related to the login screen (GNOME display manager).|
|*|samba/log.smbd|Messages from the Samba SMB file service daemon.|
|*|squid/access.log|Contains messages related to the squid proxy/caching server.|
|*|vsftpd.log|Contains messages relating to transfers made using the vsFTPd daemon (FTP server).|
|*|sendmail|Error messages recorded by the sendmail daemon.|
|*|uucp|Status messages from the Unix to Unix Copy Protocol daemon.|
|*|snort|SNORT|
|*|/aide/aide.log|AIDE, Advanced Intrusion Detection Environment|
