#!/bin/bash
# Inspired by https://gohugo.io/hosting-and-deployment/hosting-on-github/

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail

SCRIPT_DIR=`dirname "$(readlink -f "$0")"`
pushd $SCRIPT_DIR > /dev/null

if [ "`git status -s`" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

# We don't know if we're in a freshly-cloned repo, or if the repo has been
# properly set up to publish. So let's just reset the state of this repo
# as if it had never been set up for publishing, and then set it up ourselves.
echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publish to GitHub pages"

echo "Use \"git push --all\" to finish publishing."

popd > /dev/null
