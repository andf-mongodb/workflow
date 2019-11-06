# Core Workflow Tools
Contains a series of Bash wrappers to automate using a git-based docstools workflow (like at MongoDB). For best results, place in $PATH!

Comprised of the following tools:

## workflow
Checks out a new branch in your docs workspace and sets it up for work, then opens new VS Code workspace in that repo.

_Usage:_ `workflow DOC-12345-fix-typo-in-example` from anywhere on the box.

## deploy
Stages the repo for viewing in a webbrowser.

_Usage:_ `deploy` from within the git repo you wish to stage.

## review
Submits your changes for code review using the MDB internal Rietveld tool. If the first round of CR, uses the new CR ID. If a subsequent round, re-uses the existing one. Requires locally storing the CR ID for now.

_Usage:_ `review` from within the git repo you wish to submit.

## publish
Once LGTM has been obtained, submits the code as-is to Git Hub, and provides links to the next three web-based steps (Close JIRA, close CR, PR in GitHub)

_Usage:_ `publish` from within the git repo you wish to publish.

# Supporting Tools
Contains a collection of small support scripts.

## giteditor_autoamed
Used by `review` to handle `git commit --amend` situations where the commit message is not changed

## cleanspace
Clear out all build directories from all local git repos

## rebasefork
Updates your forked copy of MDB docs with the latest from upstream.
