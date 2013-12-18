#!/bin.bash

input=$1

awk -F'\t' '{gsub("一", "1", $3); gsub("二", "2", $3); gsub("三", "3", $3); gsub("附", "4", $3); gsub("名", "n", $2);  gsub("动", "v", $2); gsub("形", "a", $2); gsub("副", "v", $2); gsub("代", "r", $2); gsub("介", "p", $2); gsub("连", "c", $2); gsub("量", "q", $2); gsub("数", "m", $2); gsub("、", "", $2); gsub("助", "u", $2); print $0}' $input > $input.tran
