#!/bin/sh

user="pkeane"
pass="twitter8"
curl="/usr/bin/curl"

$curl --basic --user "$user:$pass" --data-ascii "status=`echo $@ | tr ' ' '+'`" http://twitter.com/statuses/update.json 

status=$?

echo "Your tweet returned a status code of $status"

exit 0

