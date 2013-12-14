#!/bin/bash

input=$1

awk '{{gsub("（", "("); gsub("）", ")"); gsub(/\(.*\)\/w/, ""); print$0}}' $input | while read LINE; do echo $LINE | wc -w; done  > $input.words.count
