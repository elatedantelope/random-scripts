#!/bin/sh
# use as ./gdown.sh "google drive download url"
#assigns url to the first argument
url="$1"
#extract the id from the url
ggID=`echo ${url} | egrep -o '(\w|-){26,}' `
#set the base download url
ggURL='https://drive.google.com/uc?export=download'
#Fetch the download page while saving cookies and then extract the filename from the web page text
filename="$(wget --save-cookies  /tmp/gcokie --keep-session-cookies "${ggURL}&id=${ggID}" -O - | grep -o '="uc-name.*</span>' | sed 's/.*">//;s/<.a> .*//')"
#extract the confirmation code from the cookie
getcode="$(awk '/_warning_/ {print $NF}' /tmp/gcokie)"
#finally use wget to download with -c option for continuing
wget --keep-session-cookies --load-cookies /tmp/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}" -c -O "${filename}"
