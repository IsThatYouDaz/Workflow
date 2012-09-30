#!/bin/bash
FULLNAME=`git config user.name`
TODAY=`date +%A`
YESTERDAY=`date -v -1d +%A`
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
	git checkout master
fi
echo 'Updating master'
git pull origin master

echo 'Creating and checking out todays working branch'
git checkout -b $TODAY_BRANCH_NAME

echo 'Removing previous days branch'
git branch -d $YESTERDAY_BRANCH_NAME