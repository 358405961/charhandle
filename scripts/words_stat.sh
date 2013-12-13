#!/bin/bash

input=$1

sort -g $input | uniq -c | awk '{print $2"\t"$1}' >$input.words.stat 
