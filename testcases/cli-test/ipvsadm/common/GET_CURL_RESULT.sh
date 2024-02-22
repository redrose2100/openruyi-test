#!/usr/bin/bash
count=0
while [ "$count" -lt 6 ]
do
    count=$((count+1))
    curl ipvs_vip >>/tmp/result_curl.txt
done
