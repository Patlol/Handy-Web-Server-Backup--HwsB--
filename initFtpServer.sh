#!/bin/bash

#------------------------------------------------------------------------------------------------
#   version		0.1
#   copyright		Copyright (C) Patlol <patlol@share1underground.com>. All rights reserved.
#   license		GNU General Public License version 2 or later.
#------------------------------------------------------------------------------------------------

renice 19 -p $$ &>/dev/null

# $ftphost $ftplogin $ftppw $ftpport $nameLogFile $ftproot period daily weekly monthly
#   $1        $2      $3       $4        $5         $6          $7       $8     $9


formatTerm ()  # if $term one digit add "0"
{
    if [[ $term =~ ^.$  ]]  # if matching = true
    then
        term0="0"$term
    else
        term0=$term
    fi
}
# ------------------- main ------------------------------

echo "---- Directories tree initialization on ftp server ----" >>$5

seq1="mdelete *\nmkdir files\nmdelete files/*\nmkdir www\nmdelete www/*\nmkdir mysql\nmdelete mysql/*\ncdup"

ftp -inv < <(
echo "open ${1} ${4}"
echo "user ${2} ${3}"
echo "mkdir $6"
echo "cd $6"
echo "mdelete *"  # if directory already exist
if [ ${7} -eq 1 ]  # days directories d[1-7]
then
    for ((d=1; d <= 7 ; d++))
    do
        echo "mkdir d0"$d
        echo "cd d0"$d
        echo -e $seq1
    done
fi
if [ ${8} -eq 1 ] # weeks directories w[01-08-15-22]
then
    for ((term=1; term <= 22 ; term=`expr $term + 7`))
    do
        formatTerm  # if $term one digit add "0"
        echo "mkdir w"$term0
        echo "cd w"$term0
        echo -e $seq1
    done
fi
if [ ${9} -eq 1 ] # months directories m[01-12]
then
    for ((m=1; m <= 12 ; m++))
    do
        formatTerm  # if $term one digit add "0"
        echo "mkdir m"$term0
        echo "cd m"$term0
        echo -e $seq1
    done
fi
echo "exit"
) >>$5 2>&1

echo "Exit connection: "$? >>$5
echo "The directory "$6" is ready" >>$5
echo "---- End of initialization ----" >>$5
echo >>$5