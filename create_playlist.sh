#!/bin/bash

PATH_TO_SCAN=$1;

GREP_PATH=$2

FORMAT=$3



SCAN_DIR() {
    ls -R $PATH_TO_SCAN | awk '
    /:$/&&f{s=$0;f=0}
    /:$/&&!f{sub(/:$/,"");s=$0;f=1;next}
    NF&&f{ print s"/"$0 }'
}

SCAN_DIR_AND_GREP_FORMAT() {
    ls -R $PATH_TO_SCAN | awk '
    /:$/&&f{s=$0;f=0}
    /:$/&&!f{sub(/:$/,"");s=$0;f=1;next}
    NF&&f{ print s"/"$0 }' | grep -e "$GREP_PATH" | grep -e "$FORMAT" | sed 's/ /%20/g' | sed 's,/home/rkn,http://192.168.9.104,g'
}

NAME_OF_FILES() {
    ls -R $PATH_TO_SCAN | awk '
    /:$/&&f{s=$0;f=0}
    /:$/&&!f{sub(/:$/,"");s=$0;f=1;next}
    NF&&f{ print s"/"$0 }' | grep -e "$GREP_PATH" | grep -e "$FORMAT" | sed 's,/home/rkn,http://192.168.9.104,g' | sed 's/.*\///'
}

i=1;

NAME_OF_FILES | while read -r a;
do

           echo '#EXTINF:0,'"$a" >> plst.m3u
     SCAN_DIR_AND_GREP_FORMAT | sed -n ${i}p >> plst.m3u
#           echo "$b"

    let i++


done

mv plst.m3u Torrent
