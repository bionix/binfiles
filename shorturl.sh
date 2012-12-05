#!/bin/sh
#  This script is used to cut/shorten a long url
#  Depends: curl
echo -n "Enter the Long URL : "
read url
cut_url=$(curl -s http://tinyurl.com/api-create.php?url=${url})
echo "Short URL is : ${cut_url}"
exit 0
#EOF
