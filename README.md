Handy web server Backup  HwsB
===========

_useful, convenient, practical, easy-to-use, well-designed, user-friendly, user-oriented, helpful, functional, serviceable BackUp via ftp_


Bash script for linux server, MySQL database, usable even with plesk

Save backup on remote ftp server linux or unix

Tested on linux server Ovh with Plesk and ftp server Ovh

Fully configurable:
------------------

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
