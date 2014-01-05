#!/bin/bash

input_file=$1

while read orgline
do
    line=`printf "$orgline" | awk '{gsub(/.\/w/, ""); gsub(/\/./, ""); print $0}'`
    baword=`printf "$line" | awk -F'\t' '{print $1}'`
    i=0
    flag=0
    for word in $line
    do
        if [ $i -eq 0 ]
        then
            i=`expr $i + 1`
            continue
        fi
        i=`expr $i + 1`
        if [ "$word" == "$baword" ]
        then
            flag=1
            break
        fi
    done
    if [ $flag -eq 0 ]
    then
        printf "$orgline""\n"
    fi
done < $input_file
