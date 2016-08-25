#!/bin/bash
#The script download the manifest file of the given hls stream, parse it and downloads the ts chunks from the stream. logs the details to hls.log in the current directory.
#Revision 1.0
#author : Randeep
#Contact : randeep123@gmail.com

#creating channel directory
mkdir -p channels && cd channels

url=$1
channelname=`cut -d "/" -f 5 <<< $url`
mkdir -p /ssd/hls/channels/"$channelname" && cd /ssd/hls/channels/"$channelname"

cleanup(){
        rm -f *.m3u8* *.ts*
}

while true
do
        #deleting existing .m3u8 and .ts files
        cleanup

        #Getting the manifest file
        wget "$url" -o /dev/null

        #Creating the baseurl so that the chunks can be appendend to it and requested.
        baseurl=`cut -d "/" -f 1,2,3,4,5 <<< "$url"`
        #echo -e "Baseurl is : $baseurl" #>> hls_$channelname.log

        #Parseing the name of the highest resolution/bitrate manifest
        submanifestname=`cat index.m3u8 | grep 1- | tr -d '\r'`
        suburl="$baseurl"/"$submanifestname"
        #echo -e "`date` submanifesturl is : $suburl" #>> hls_$channelname.log

        #Downloading the submanifest
        wget "$suburl" -o /dev/null
        for i in `cat "$submanifestname" | grep 1-`
                do
                        #echo -e "`date` $baseurl/`echo $i|tr -d '\r'`" #>> hls_$channelname.log
                        wget "$baseurl"/`echo $i|tr -d '\r'` -O /dev/null -o /dev/null
                done

        #deleting existing .m3u8 and .ts files
        cleanup
        sleep 3
done
