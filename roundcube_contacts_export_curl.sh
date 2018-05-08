#!/bin/bash

user="someuser"
url="url of remote server"
PASS="somepass"

token=`curl -c cookies -X GET $url |grep "name=\"_token" |sed 's/.*value="\([^"]*\)".*/\1/'`

curl -L -b cookies -c cookies -X POST -e $url -F"_action=login" -F"_pass=$PASS" -F"_task=login" -F"_timezone=Europe/Berlin" -F"_token=$token" -F"_url=" -F"_user=$user" $url > /dev/null

result=`curl -L -b cookies -c cookies -X GET -F"_task=addressbook" -F"_action=export" -e $url $url | grep "name=\"_token" |grep -Po 'name="_token" value="\K[[:word:]]*'`

curl -o contacts.vcf -L -b cookies -c cookies -X GET -F"_task=addressbook" -F"_action=export" -F"_source=0" -F"_token=$result" -e $url -s "$url/?_task=addressbook&_source=0&_action=export&_token=$result" > /dev/null

cat contacts.vcf
