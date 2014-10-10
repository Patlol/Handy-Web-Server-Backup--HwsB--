#!/bin/bash

#------------------------------------------------------------------------------------------------
#   version		0.1
#   copyright		Copyright (C) Patlol <patlol@share1underground.com>. All rights reserved.
#   license		GNU General Public License version 2 or later.
#------------------------------------------------------------------------------------------------

renice 19 -p $ &>/dev/null

# parse parameters
i=0
for param in $@
do
    path[$i]=$param
    ((i++))
done

# the last parameter and the next to last
pathBackup=${path[((--i))]}"/save/www/"
log=${path[((--i))]}

# Verifies that exists /save/www
if ! [ -d $pathBackup ]
then
    mkdir -p $pathBackup
fi

# processing others parameters
y=0  # index
# $i = number of directory to save
while [ "$y" -lt "$i" ]
do
    echo "-- tar of website "${path[$y]}" --" >>$log
    # keeps only the name of the directory to save
    # switch "/" by "-" ^\/ don't use the first "/" \//-/ replace all "/" by "-"
    zipName=`echo ${path[$y]} | sed -e 's/^\///; s/\//-/g'`
    tar -czf ${pathBackup}${zipName}.tgz ${path[$y]} 2>>$log
    echo "Exit : "$? >>$log
    ((y++))
done
