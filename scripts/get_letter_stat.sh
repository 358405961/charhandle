#!/bin/bash

input_file=$1
words_file=$2
lel1=0
lel2=0
lel3=0
lel4=0
lel5=0


for line in `cat $input_file`
do
    newline=$(echo $line | sed 's/\(.\)/\1 /g')
    for letter in $newline
    do
        level=`grep -n "$letter" $words_file | awk '{print $2}'`
        #echo $letter $level
        if [ "$level" == "" ]
        then
            lel5=`expr $lel5 + 1`
        elif [ $level -eq 1 ]
        then
            lel1=`expr $lel1 + 1`
        elif [ $level -eq 2 ]
        then
            lel2=`expr $lel2 + 1`
        elif [ $level -eq 3 ]
        then
            lel3=`expr $lel3 + 1`
        elif [ $level -eq 4 ]
        then
            lel4=`expr $lel4 + 1`
        else
            lel5=`expr $lel5 + 1`
        fi
    done
done

echo $lel1 $lel2 $lel3 $lel4 $lel5
