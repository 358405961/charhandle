#!/bin/bash

input_file=$1
words_file=$2


i=0
ifs=$IFS
IFS=$'\n'
for line in `cat $input_file`
do
    INPUT[i]=`echo $line | awk '{print $1}' `
    i=`expr $i + 1`
done
IFS=$ifs

rm -f "$input_file.exclude" "$input_file.include"

input_len=${#INPUT[*]}  
for((i=0;i<$input_len;i=i+1)) 
do
    flag=0
    k=0
    ifs=$IFS
    IFS=$'\n'
    for line in `grep  "${INPUT[$i]}" $words_file`
    do
        WORDS[k]=$line
        k=`expr $k + 1`
    done
    IFS=$ifs

    words_len=$k
    if [ $k -eq 0  ]
    then
        echo -e "${INPUT[$i]}" >> "$input_file.exclude"
        continue
    fi
    for((j=0;j<$words_len;j=j+1))
    do
        words=`echo ${WORDS[$j]} | awk '{print $1}'`
        words_property=`echo ${WORDS[$j]} | awk '{print $2}'`
        words_level=`echo ${WORDS[$j]} | awk '{print $3}'`
        is_verb=`echo $words_property | grep "v"`

        if [ "$words" == "${INPUT[$i]}" ] 
        then
            if [ "$is_verb" == "v"  ] || [ "$is_verb" == ""  ]
            then 
                echo -e "$words""\t""$words_level" >> "$input_file.include"
            else
                echo -e "$words""\t""$words_level" >> "$input_file.exclude"
            fi
            flag=1
            continue
        fi
    done
    if [ $flag -eq 0 ]
    then
        echo -e "${INPUT[$i]}" >> "$input_file.exclude"
    fi
done
