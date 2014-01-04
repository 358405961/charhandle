#!/bin/bash

input_file=$1
words_file=$2
letter_file=$3

while read line
do
printf "$line""\t"
    for word in $line
    do
        word_cxt=${word%%/*}
        word_prop=${word##*/}
        if [ "$word" == "$word_prop" ]
        then
            word_prop="v"
        fi
        if [ "word_prop" != "g" ] && [ "$word_prop" != "x" ]
        then
            ifs=$IFS
            IFS=$'\n'
            flag=0
            for lin in `grep  "^""$word_cxt"" " $words_file`
            do
                lin_word=`echo $lin | awk '{print $1}'`
                lin_prop=`echo $lin | awk '{print $2}'`
                lin_lvl=`echo $lin | awk '{print $3}'`
                prop=`echo $lin_prop | grep $word_prop`
                if [ "$word_cxt" == "$lin_word" ] 
                then
                    flag=1
                    if [ "$prop" != "" ]
                    then
                        #printf "$lin_lvl "
                        printf ""
                        break
                    elif [ "$lin_prop" == "" ] || [ "$word_prop" == "j" ] || [ "$word_prop" == "l"  ] || [ "$word_prop" == "i"  ] || [ "$word_prop" == "z"  ] || [ "$word_prop" == "b"  ]
                    then
                       #printf "$lin_lvl "
                       printf ""
                       break
                    else
                       #printf "$word_cxt/$word_prop"
                       #printf "x "
                       continue
                    fi
                else
                    continue
                fi
            done
            IFS=$ifs
            if [ $flag -eq 0 ]
            then
                printf "$word_cxt/$word_prop"
                printf "x "
            fi
            #printf "\n"
        else
            printf "$word_cxt $word_prop"
            lin=`grep  "$word_cxt" $letter_file`
            lin_word=`echo $lin | awk '{print $1}'`
            lin_lvl=`echo $lin | awk '{print $2}'`
            if [ "$word_cxt" == "$lin_word" ]
            then
                #printf "$lin_lvl "
                printf ""
            else
                printf "$word_cxt/$word_prop"
                printf "x "
            fi
            #printf "\n"
        fi
    done
    printf "\n"
done < $input_file
