#!/bin/bash

input=$1

 awk '{gsub(".", "。"); gsub("。", ""); gsub("!", "！"); if($2 != ""){print $0"。"}; }' $input | awk '{gsub("！。", "！"); gsub("？。", "？"); gsub("”。", "”"); print $0}' > $input.fix
