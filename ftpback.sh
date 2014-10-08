#!/bin/bash
#------------------------------------------------------------------------------------------------
#   version		0.1
#   copyright		Copyright (C) Patlol <patlol@share1underground.com>. All rights reserved.
#   license		GNU General Public License version 2 or later.
#------------------------------------------------------------------------------------------------
#   tested on OVH Ftp Unix server and linux server

# $ftphost $ftplogin $ftppw $ftpport $nameLogFile $pathBackup $ftproot period daily weekly monthly
#   $1        $2      $3       $4        $5         ${6}          $7          $8       $9     $10

formatMonth ()  # if $term one digit add "0"
{
    if [[ $deleteMonth =~ ^.$  ]]  # if matching = true
    then
        deleteMonth0="0"$deleteMonth
    else
        deleteMonth0=$deleteMonth
    fi
}

rotateMonth()
{
    deleteMonth=`expr $month - 3`
    # if we are on 01 02 03 must delete 10 11 12 and $deleteMonth = -2 -1 0
    if [ $deleteMonth -le 0 ]
    then
        deleteMonth=`expr $deleteMonth + 12`
    fi
    formatMonth  # for $deleteMonth 1-9 => 01-09
    # delete the month = $deleteMonth
    echo "cd "${7}"/m"${deleteMonth}"/files"
    echo "mdelete *"
    echo "cdup"
    echo "cd www"
    echo "mdelete *"
    echo "cdup"
    echo "cd mysql"
    echo "mdelete *"
    echo "cd "${7}
}
# ------------- main -----------------------------------

echo "-- Data ftp transmission --" >>$5
numDay="0"`date +%u`  # monday = 1 [1-7] !1!!!
dateDay=`date +%d` # date [01-31]     !01!!!
month=`date +%m`   # [01-12]           !01!!!
logDaily=""
logWeekly=""
logMonthly=""

ftp -inv < <(
echo "open ${1} ${4}"
echo "user ${2} ${3}"
echo "binary"

if [[ ${8} -eq 1 ]]  # daily backup d1/ d2/ ... [1-7]
then
    echo "cd "${7}"/d"${numDay}"/files"
    echo "mdelete *"
    echo "lcd "${6}"/save/files"
    echo "mput *"
    echo "cdup"
    echo "cd www"
    echo "mdelete *"
    echo "lcd "${6}"/save/www"
    echo "mput *"
    echo "cdup"
    echo "cd mysql"
    echo "mdelete *"
    echo "lcd "${6}"/save/mysql"
    echo "mput *"
    echo "cd "${7}
    logDaily=" daily d"${numDay}
fi

# exreg="\(01\|08\|15\|22\)"
# weekly backup 1 8 15 22 each month
if [[ ${9} -eq 1 && $dateDay =~  01|08|15|22 ]]    # `expr match "$dateDay" $exreg` ]]
then
    echo "cd "${7}"/w"${dateDay}"/files"
    echo "mdelete *"
    echo "lcd "${6}"/save/files"
    echo "mput *"
    echo "cdup"
    echo "cd www"
    echo "mdelete *"
    echo "lcd "${6}"/save/www"
    echo "mput *"
    echo "cdup"
    echo "cd mysql"
    echo "mdelete *"
    echo "lcd "${6}"/save/mysql"
    echo "mput *"
    echo "cd "${7}
    logWeekly=" weekly w"${dateDay}
fi

if [[ ${10} -eq 1 && 10#$dateDay -eq 1 ]] # monthly backup [01-12] 0x octal 10# force decimal
then
    rotateMonth
    echo "cd "${7}"/m"${month}"/files"
    echo "lcd "${6}"/save/files"
    echo "mput *"
    echo "cdup"
    echo "cd www"
    echo "lcd "${6}"/save/www"
    echo "mput *"
    echo "cdup"
    echo "cd mysql"
    echo "lcd "${6}"/save/mysql"
    echo "mput *"
    echo "cd "${7}
    logMonthly=" monthly m"${month}
fi

echo "exit"
) >>$5 2>&1

echo "Exit connection: "$? >>$5
echo "********************************************************" >> $5
echo "ftp repertory:"${logDaily}${logWeekly}${logMonthly} >>$5