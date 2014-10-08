Handy web server Backup  HwsB
===========

_useful, convenient, practical, easy-to-use, well-designed, user-friendly, user-oriented, helpful, functional, serviceable BackUp via ftp_


Bash script for linux server, MySQL database, usable even with plesk
Save backup on remote ftp server linux or unix
Tested on linux server Ovh with Plesk and ftp server Ovh

-------

Fully configurable:
------------------

* Backup period "on" or "off", empty = off

  1. Daily: every day, 7-day rotation   
    `dailyBackup="on"`

  2. Weekly: the 1st, 8th, 15th and 22nd of month. 4-week rotation    
    `weeklyBackup="on"`

  3. Monthly: first of each month, 3-month rotation    
    `monthlyBackup="on"`

* Path where the backup and log files are written, for pathBackup="/root" the files are on /root/save/ and /root/log/    
  `pathBackup="/aaa/bbb/ccc"`

* List of directorie(s) to backup (full path, each path separated by space) exexcluding website    
  `pathFileSave="/ddd/eee /fff/ggg /hhhh/ii"`

* List of website(s) path(s) to backup (full path, each path separated by space)    
  `pathSiteSave="/jjj/kkk/lll/mmmm /nnn/ooo/ppp/ttt"`

* Informations for database(s) backup(s) (each separated by space)   
  syntax: "name_base1 user_base1 password_base1 name_base2 ......."   
  With Plesk you can use nupMysql="db1 admin \`cat /etc/psa/.psa.shadow\`"   
  `nupMysql="db1 toto azerty db2 coco qwerty"`

* ftp login. Tested on Ovh ftp backup service.   
  `ftplogin="juju"`

* ftp host. (IP or domain name)   
  `ftphost="xxx.xxx.xxx.xxx"`

* ftp port (if empty ftpport = 21)    
  `ftpport=""`

* ftp pass word. No space!!!   
  `ftppw="azertyqwerty"`

* ftp backup root path on ftp server. Attention to the directories attributes    
  `ftproot="/uuu/vvv/www"`

* Mail server name host ( if empty mailhost = /etc/hostname )    
  `mailhost=""`

* Mail from: what you want. No space!!!    
  `mailfrom="system"`

* Mail to: more one adress is possible (each separated by semicolon, no space)
  if empty don't send mail !    
  `mailto="titi@exemple.com;lolo@exemple2.net"`

* exec sendmail path ( if empty pathsendmail = /usr/sbin/sendmail )    
  `pathsendmail=""`

--------

Use
---

After unzip run _./hwsb.sh_

you can have multiple configuration files:    
By example for a site `./hwsb.sh site1.conf`     
then to another site with different periods  `./hwsb.sh site2.conf`

At first use hswb creates the tree on the ftp backup server, depending on the configuration of the backup period (Daily, weekly, monthly)

Don't forget to set up cron to run it every night

__Warning__ ftp backup ovh servers are only accessed from the ovh dedicated server that is attached

---------

Utilities directory
----

_restoresql.sh_ Will retrieve tables of a database from the ftp backup server on the server where the script runs   
  usage: `restoresql.sh -n databaseName -u userName -p passWord [sqlFilesRepertory (default: ./sql)]`
  
_cleanFtpServer.sh_ Destroyed the backup directories and files from backups    
  usage: `./cleanFtpServer.sh [configuration file name: xxxx.conf]`

-------

Acknowledgments
----------
The one who was at the origin of this project: [Yann Dubois](http://www.yann.com/fr/dedie-ovh-sauvegarde-automatisee-ftp-gratuite-06/05/2011.html)

---------

__Feedback is welcome.__ Issues and pull requests can be submitted via GitHub. Fork unrestrained and...

 Enjoy!
-----
