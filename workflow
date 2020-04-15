#!/bin/bash

## Bash script to automate MongoDB new doc branch setup.
## You must pass your intended branchname as the single
## positional parameter when you invoke this script, like:
##   workflow DOC-12345-fix-typo-in-example

############################################################
## YOUR VALUES ##
#################

## Your github username:
GITUSER=andf-mongodb

## Your docs workspace (i.e. where to git clone to)
## If you use a ~ in the path, don't quote the value:
WORKSPACE=~/doc_workspace

## Directory to store workflow-specific status:
WORKFLOW_STATUS_DIR=$WORKSPACE/workflow

############################################################
## BEGIN SCRIPT ##
##################

## Default to Master unless overridden with -b:
UPSTREAM_BRANCH="master"

## Check for UPSTREAM_BRANCH override: for publishing directly
## to future release branches, like v4.2.1:
while getopts ":b:v:" opt; do
  case ${opt} in
    b )
      UPSTREAM_BRANCH=$OPTARG
      ;;
    v )
      UPSTREAM_BRANCH=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      ;;
    : )
      echo -e "\nERROR: If you specify -$OPTARG, you must provide a branch name (like 'v4.2.1')" 1>&2
      ;;
  esac
done
shift $((OPTIND -1))

## Collect intended branchname from provided parameter:
BRANCHNAME=$1

## If $UPSTREAM_BRANCH does not begin with a 'v' character, add it:
if [ `echo $UPSTREAM_BRANCH | grep -c '^v.*'` -lt 1 ]; then
   UPSTREAM_BRANCH=`echo v$UPSTREAM_BRANCH`
fi

## Sanity check on #UPSTREAM_BRANCH
if [ `echo $UPSTREAM_BRANCH | egrep -c 'v[0-9]\.[0-9]{1,2}\.{0,1}[0-9]{0,2}$'` -lt 1 ]; then
   echo -e "\nERROR: Upstream branch override provided, but mangled."
   echo -e "       Should be a valid MDB version number, like 'v4.2' or 'v4.2.1'."
   echo -e "       Exiting ...\n"
   exit;
fi

# Quit if no parameters were passed or if $BRANCHNAME is incomplete:
if [ -z $BRANCHNAME ]; then
   echo -e "\nERROR: You must provide the intended branch name as a parameter."
   echo -e "       Exiting ...\n"
   exit;
elif [ `echo $BRANCHNAME | awk -F\- '{print NF-1}'` -lt 2 ]; then
   echo -e "\nERROR: Your branchname must consist of a JIRA TICKET + a DESCRIPTION."
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

if [ ! -f $WORKFLOW_STATUS_DIR/$BRANCHNAME ]; then
   touch $WORKFLOW_STATUS_DIR/$BRANCHNAME
fi

git pull upstream
git checkout -b $BRANCHNAME upstream/$UPSTREAM_BRANCH
git pull --rebase

## Rename `docs` based on BRANCHNAME:
cd ..
mv docs docs_$BRANCHNAME

## Open new branch in VS Code:
cd docs_$BRANCHNAME
code .

## Exit, for now.
