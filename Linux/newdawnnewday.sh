#!/bin/bash

#functions
function throwException {
		echo ' '
		echo '!! ERROR - DAILY BRANCH NOT CREATED !!'
		echo 'FIX THE ABOVE PROBLEMS AND RUN THIS PROCESS AGAIN'
		echo 'PRESS ANY KEY TO EXIT'
    	read anyKey
    	exit
}

#main
FULLNAME=`git config user.name`
TODAY=`date +%A`
YESTERDAY=`date --date=yesterday +%A`
CURRENT_BRANCH=`git branch | grep "*" | sed "s/* //"`
IS_CLEAN=`git status | grep -c "nothing to commit"`


for word in $FULLNAME; do
	INITALS=$INITALS${word:0:1}
done

TODAY_BRANCH_NAME=$INITALS"_"$TODAY
YESTERDAY_BRANCH_NAME=$INITALS"_"$YESTERDAY

IS_PUSHED=`git branch -a | grep -c $TODAY_BRANCH_NAME`

if [ "$IS_CLEAN" == "0" ]; then
	echo ' '
	echo 'Changes outstanding to be commited, please commit and push these changes before running newdawnnewday again'
	throwException
fi

if [ "$IS_PUSHED" == "1" ]; then
	echo ' '
	echo 'You have not pushed your daily branch, please push your daily branch and inform your merge manager'
	throwException
fi
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
	checkoutMaster=$?
	if [[ $checkoutMaster != 0 ]] ; then
		throwException
	fi

fi

echo 'Updating master'
git pull origin master
pullSuccess=$?
if [[ $pullSuccess != 0 ]] ; then
	throwException
fi

echo 'Creating and checking out todays working branch'

DAILY_EXISTS=`git branch | grep -c $TODAY_BRANCH_NAME`


if [ "$DAILY_EXISTS" == "1" ] ; then
	echo 'This daily branch already exists attempting cleanup'
	git branch -d $TODAY_BRANCH_NAME
	dailyRemoveSuccess=$?
	if [[ $dailyRemoveSuccess != 0 ]] ; then
		throwException
	fi
	git push origin :$TODAY_BRANCH_NAME
	dailyOriginRemovalSuccess=$?
	if [[ $dailyOriginRemovalSuccess != 0 ]] ; then
		throwException
	fi
fi

git checkout -b $TODAY_BRANCH_NAME
checkoutDailySuccess=$?
if [[ $checkoutDailySuccess != 0 ]] ; then
	throwException
fi

YESTERDAY_EXISTS=`git branch | grep -c $YESTERDAY_BRANCH_NAME`

if [ "$YESTERDAY_EXISTS" == "1" ] ; then
	echo 'Removing previous days branch'
	git branch -d $YESTERDAY_BRANCH_NAME
	yesterdayRemoveSuccess=$?
	if [[ $yesterdayRemoveSuccess != 0 ]] ; then
		throwException
	fi
	git push origin :$YESTERDAY_BRANCH_NAME
	originRemovalSuccess=$?
	if [[ $originRemovalSuccess != 0 ]] ; then
		throwException
	fi
fi

#modifed test