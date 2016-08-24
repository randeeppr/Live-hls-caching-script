#!/bin/bash
#This scripts reads the hls_input.txt file which contains the urls and invokes hls_from_file.sh script for each url
for i in `cat hls_inputs.txt`
do
  /bin/sh hls_from_file.sh $i &
done
