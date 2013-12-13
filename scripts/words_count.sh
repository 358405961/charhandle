#!/bin/bash

input=$1

iconv -f utf-16le -t utf-8 $input | awk '{{gsub("（", "("); gsub("）", ")"); gsub(/\(.*\)\/w/, ""); print$0}}' | while read LINE; do echo $LINE | wc -w; done  > $input.words.count
