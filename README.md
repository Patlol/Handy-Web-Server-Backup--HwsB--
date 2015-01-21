Handy web server Backup  HwsB
===========

_useful, convenient, practical, easy-to-use, well-designed, user-friendly, user-oriented, helpful, functional, serviceable BackUp via ftp_


Bash script for linux server, MySQL database, usable even with plesk
Save backup on remote ftp server linux or unix
Tested on linux server Ovh with Plesk and ftp server Ovh

-------

Fully configurable:
------------------

[See wiki](https://github.com/Patlol/Handy-Web-Server-Backup--HwsB--/wiki/Fully-configurable)

--------

Use
---

After unzip run _./hwsb.sh_

You must fill the configuration file   
You can have multiple configuration files:    
By example for a site `./hwsb.sh site1.conf`     
then to another site with different periods  `./hwsb.sh site2.conf`

At first use hswb creates the tree on the ftp backup server, depending on the configuration of the backup period (Daily, weekly, monthly)

Don't forget to set up cron to run it every night

__Warning__ ftp backup ovh servers are only accessed from the ovh dedicated server that is attached

---------

Utilities directory
----

_restoresql.sh_ Will retrieve tables of a database from the ftp backup server to the server where the script runs   
  usage: `restoresql.sh -n databaseName -u userName -p passWord [sqlFilesRepertory (default: ./sql)]`
  
_cleanFtpServer.sh_ Destroyed the backup directories and files from backups    
  usage: You must fill the configuration file  
  `./cleanFtpServer.sh [configuration file name: xxxx.conf (default: ./cleanFtpServer.conf)]`

-------

Acknowledgments
----------
One whose script gave me the idea for this project: [Yann Dubois](http://www.yann.com/fr/dedie-ovh-sauvegarde-automatisee-ftp-gratuite-06/05/2011.html)

---------

__Feedback is welcome.__ Issues and pull requests can be submitted via GitHub. Fork unrestrained and...

 Enjoy!
-----
