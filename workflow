#!/bin/bash

## Bash script to automate MongoDB new doc branch setup.
## You must pass your intended branchname as the single
## positional parameter when you invoke this script, like:
##   workflow DOC-12345-fix-typo-in-example

############################################################
## YOUR VALUES ##
#################

## Your github username:
GITUSER=your_github_username

## Your docs workspace (i.e. where to git clone to)
## If you use a ~ in the path, don't quote the value:
WORKSPACE=~/doc_workspace

############################################################
## BEGIN SCRIPT ##
##################

## Collect positional parameters:
## 1: Intended branch name (i.e. Jira ticket # + description)
BRANCHNAME=$1

# Quit if no parameters were passed:
if [ -z $BRANCHNAME ]; then
   echo -e "\nERROR: You must provide the intended branch name as a parameter."
   echo -e "       Exiting ...\n"
   exit;
fi

# Quit if $WORKSPACE/docs dir already exists
# (git would refuse anyways)
if [ -d $WORKSPACE/docs ]; then
   echo -e "\nERROR: A \"docs\" directory already exists in"
   echo "       $WORKSPACE"
   echo -e "       Exiting ...\n"
   exit;
fi

## Start new repo setup:
cd $WORKSPACE
git clone git@github.com:$GITUSER/docs.git
cd docs
git remote add upstream git@github.com:mongodb/docs.git
sed -i '' 's%remote = origin%remote = upstream%g' .git/config
git pull upstream
git checkout -b $BRANCHNAME upstream/master
git pull --rebase

## Rename `docs` based on BRANCHNAME:
cd ..
mv docs docs_$BRANCHNAME

## Open new branch in VS Code:
cd docs_$BRANCHNAME
code .

## Exit, for now.
