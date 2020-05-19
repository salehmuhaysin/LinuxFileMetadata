#!/bin/bash



convert_time(){

	date -d @$1 -u -Ins | awk -F ',' '{print $1}'| sed 's/T/ /g'
}


# search for paths
LIST_FILES=$(find "/" -regextype posix-extended -regex "/(sys|srv|proc|dev)" -prune -o -type d 2> /dev/null ) 

# copy all files to the ./output folder
IFS=$'\n'       # make newlines the only separator
for f in $LIST_FILES
do
	FILENAME="$f"
	LAST_ACCESS=$(convert_time $(stat "$f" -c %X) )
	CREATED_DATE=$(convert_time $(stat "$f" -c %W) )
	MODIFIED_DATE=$(convert_time $(stat "$f" -c %Y) )
	MD5SUM=$(md5sum "$f" 2> /dev/null| awk -F ' ' '{print $1}') 
	FILE_TYPE=$(stat "$f" -c %F)
	FILE_SIZE=$(stat "$f" -c %s)
	FILE_OWNER=$(stat "$f" -c %U)

	echo "$FILENAME,$MD5SUM,$FILE_SIZE,$CREATED_DATE,$MODIFIED_DATE,$LAST_ACCESS,$FILE_OWNER,$FILE_TYPE" 
done
