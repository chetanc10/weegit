#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT INT TERM

if [[ $# -gt 0 ]]; then
    git diff "$@" > "$tmp"
else
    git diff HEAD > "$tmp"
fi

eval "$(git var GIT_EDITOR) \"\$tmp\""
