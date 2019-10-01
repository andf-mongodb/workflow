# workflow (and deploy)
Bash wrappers to automate using a git-based docstools workflow (like at MongoDB). Currently, comprised of two scripts:

## workflow
Checks out a new branch in your docs workspace and sets it up for work, then opens new VS Code workspace in that repo. 
_Requires:_ Pass the intended new branch name (like DOC-12345-fix-typo-in-example) as parameter.

Tasks:
1. git clone git@github.com:YOU/docs.git
2. git remote add upstream git@github.com:mongodb/docs.git
3. Edits .git/config to switch remote to upstream from origin
4. git pull upstream
5. git checkout -b DOC-12345-fix-typo-in-example
6. git pull -- rebase
7. Renames the docs dir to docs_DOC-12345-fix-typo-in-example (optional, this is how I manage my doc_workspace)
8. Opens new branch file structre as new workspace in VS Code

Usage: `workflow DOC-12345-fix-typo-in-example` from anywhere on your system.

## deploy
Stages the repo for viewing in a webbrowser.

Tasks:
1. Clean build directory, if present
2. make html
3. make stage
4. Open the system default web browser to the stage URL

Usage: `deploy` from within the git repo you wish to stage.
