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
pathBackup=${path[((--i))]}"/save/files/"
log=${path[((--i))]}

# Verifies that exists /save/files
if ! [ -d $pathBackup ]
then
    mkdir -p $pathBackup
fi

# processing others parameters to backup
y=0  # index
# $i number of site to save
while [ "$y" -lt "$i" ]
do
    echo "-- tar of directory "${path[$y]}" --" >>$log
    # keeps only the name of the directory to save
    # switch "/" by "-" ^\/ don't use the first "/" \//-/ replace all "/" by "-"
    zipName=`echo ${path[$y]} | sed -e 's/^\///; s/\//-/g'`
    tar -czf ${pathBackup}${zipName}.tgz ${path[$y]} 2>>$log
    echo "Exit : "$? >>$log
    echo "---------------------------------------------------------" >>$log
    ((y++))
done
