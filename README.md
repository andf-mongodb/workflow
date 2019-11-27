# Core Workflow Tools
Contains a series of Bash wrappers to automate using a git-based docstools workflow (like at MongoDB). For best results, place in $PATH!

Comprised of the following tools:

## workflow
Checks out a new branch in your docs workspace and sets it up for work, then opens new VS Code workspace in that repo. Optionally supports directly checking out a different branch (i.e. v4.2.1) if performing work on a future branch directly.

_Usage:_ `workflow DOC-12345-fix-typo-in-example` from anywhere on the box.

## stage
Stages the repo for viewing in a webbrowser.

_Usage:_ `stage` from within the git repo you wish to stage.

## review
Commits your changes to git, and submits for code review using the MDB internal Rietveld tool. If the first round of CR, uses the new CR ID. If a subsequent round, re-uses the existing one. Requires locally storing the CR ID for now.

_Usage:_ `review` from within the git repo you wish to submit.

## push
Once LGTM has been obtained, submits the code as-is to Git Hub, and provides links to the next three web-based steps (PR in GitHub, Close JIRA, close CR)

_Usage:_ `push` from within the git repo you wish to publish.

## backport
Once your changes have been committed, optionally backport to previous branches if applicable. Allows for manual confliuct resolution and then resuming, and allows for editing of PRs if they haven't been completed yet.

_Usage:_ 
- `backport v4.0` after having commited the change you wish to backport, from within the branch you made the change in.
- `backport resume` to issue `git cherry-pick --continue` after a manual conflict resolution and continue to the PR.
- `backport edit` to edit an existing PR that hasn't been completed yet.

# Supporting Tools
Contains a collection of small support scripts.

## giteditor_autoamed
Used by `review` and `backport` to automate `git commit --amend` situations where the commit message is not changed

## cleanspace
Clear out all build directories from all local git repos

## rebasefork
Updates your forked copy of MDB docs with the latest from upstream.

## versioncheck
Checks through a docs corpus for `versionchanged::` tags and lists those files that include such tags older than the user-provided version. Usage: `versioncheck v3.4`

# Example workflow usage, using these tools:

1. `workflow DOC-12345-fix-typo-in-example`

2. In resulting VSCode window, edit appropriate RST and YAML files to address concerns raised in Jira ticket.

3. `stage` within VSCode terminal to preview changes in web browser (via autobuilder)

4. Repeat steps 2 and 3 until ready for review.

5. `review` from within the VSCode terminal to submit for CR when ready for feedback

6. One of:

   - CR is returned with LGTM: `push` from within VSCode terminal to create PR

   - CR comes back with feedback. Repeat steps 4-5 (edit - `stage` - `review`).

7. If necessary (as often is), backport to previous version(s) with `backport v4.0` (and `backport v3.6` and `backport v3.4`)


Occassionally, run `rebasefork` and `cleanspace`
