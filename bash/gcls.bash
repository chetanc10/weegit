#!/usr/bin/env bash
#about = Shallow clone a repo with single branch

[ $# == 0 ] && echo -e "Usage: $0 <repo-url> [branch]\nbranch defaults to master if not specified" & exit 0

url="$1"
[ -n "$2" ] && branch="$2" || branch=master

git clone --depth 1 --single-branch --branch "$branch" "$url"
exit $?
