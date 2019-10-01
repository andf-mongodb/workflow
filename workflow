#!/bin/bash

## Quick bash script to manage MongoDB Docs Workflows
## from start to finish (eventually). For now just
## does the initial setup.

## Collect positional parameters:
## 1: Jira DOCS/DOCSP ticket #
JIRA=$1

# Quit if no parameters were passed:
if [ -z $JIRA ]; then
   echo "You must provide a JIRA ticket number at least, exiting."
   exit;
fi

## Start new repo setup:

cd ~/doc_workspace
git clone git@github.com:andf-mongodb/docs.git
cd docs
git remote add upstream git@github.com:mongodb/docs.git
sed -i '' 's%remote = origin%remote = upstream%g' .git/config
git pull upstream
git checkout -b $JIRA upstream/master
git pull --rebase

## Rename `docs` based on JIRA ticket number:
cd ..
mv docs docs_$JIRA

## Open new branch in VS Code:
cd docs_$JIRA
code .

## Exit, for now.
