#!/bin/bash

input=$1

 awk '{gsub(/\/\/\/\$/, "/"); gsub(/\/\/\$/, "/"); gsub(/\/\$/, "/"); gsub(" ", ""); split($2, a, "/"); for(i in a){if(a[i]!="" && a[i]!="。"){print $1"\t"a[i]}}}' $input > $input.result
