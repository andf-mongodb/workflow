# workflow (and deploy)
Bash wrappers to automate using the MongoDB docschain toolset. Currently, comprised of two scripts:

## workflow
Checks out a new branch in your docs workspace and sets it up for work, then opens new VS Code workspace. 
Requires: Pass the intended new branch name (like DOC-12345-fix-typo-in-example) as parameter.
Tasks:
1. git clone git@github.com:YOU/docs.git
2. git remote add upstream git@github.com:mongodb/docs.git
3. Edits .git/config to switch remote to upstream from origin
4. git pull upstream
5. git checkout -b your_new_branchname
6. git pull -- rebase
7. Renames the docs dir to docs_your_new_branchname (optional, this is how I manage my doc_workspace)
8. Opens new branch file structre as new workspace in VS Code

## deploy
Stages the repo for viewing in a webbrowser by performing the following tasks:
1. Clean build directory, if present
2. make html
3. make stage
4. Open the system default web browser to the stage URL
