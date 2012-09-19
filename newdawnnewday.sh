#!/bin/bash
# decalre
FULLNAME=`git config user.name`
TODAY=`date +%A`
YESTERDAY=`date --date=yesterday +%A`
CURRENT_BRANCH=`git branch | grep "*" | sed "s/* //"`

for word in $FULLNAME; do
	INITALS=$INITALS${word:0:1}
done

TODAY_BRANCH_NAME=$INITALS"_"$TODAY
YESTERDAY_BRANCH_NAME=$INITALS"_"$YESTERDAY



#if current branch isn't master then check it out
#pull origin master
#check if it completed successfully? some how
#check if yesterdays branch is merged with master
#if it is merged git checkout -b NEW_BRANCH otherwise bail

if [ "$CURRENT_BRANCH" == "master" ]; then
	echo "We are on master"
else
	echo "Not on master - switching to it now"
	`git checkout master`
fi

`git pull origin master`
