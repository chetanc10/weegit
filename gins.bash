#!/usr/bin/env bash
set -euo pipefail

cmd="$(basename "$0")"

usage() {
    printf '%s\n' "$cmd — view or revert uncommitted file changes in a git repo.
Usage: $cmd [-h] [-d path] [-s] [-e editor] [-v]
  -h        Display this help message and exit
  -d path   Filter modified files/folders by given path
  -s        Include staged files
  -e editor Override the editor (default: ${EDITOR-})
  -v        Verbose: echo each git command
NOTE: Pressing <ENTER> at the prompt skips to the next modified file."
}

dir=""
staged=0
editor=""
verbose=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		-h) usage; exit 0 ;;
		-d) dir="${2?error: -d requires a path}"; dir="${dir#./}"; shift 2 ;;
		-s) staged=1; shift ;;
		-e) editor="${2?error: -e requires an editor}"; shift 2 ;;
		-v) verbose=1; shift ;;
		*)  printf 'error: unknown option: %s\n' "$1" >&2; usage; exit 1 ;;
	esac
done

if [[ -z "$editor" ]]; then
    if [[ -n "${EDITOR:-}" ]] && command -v "$EDITOR" &>/dev/null; then
        editor="$EDITOR"
    else
        for e in nvim vim nano; do
            command -v "$e" &>/dev/null && editor="$e" && break
        done
    fi
fi

! git rev-parse --is-inside-work-tree &>/dev/null && echo 'error: not inside a git repository\n' && exit 1

_git()
{
	(( verbose )) && printf '  $ git %s\n' "$*" >&2
	git "$@"
}

modlist="$(mktemp)"
trap 'rm -f "$modlist"' EXIT

_git diff --name-only > "$modlist"
if (( staged )); then
	_git diff --cached --name-only >> "$modlist"
	sort -u -o "$modlist" "$modlist"
fi
[[ ! -s "$modlist" ]] && echo 'No changes found.\n' && exit 0

_act()
{
	local f="$1"
	while true; do
		read -n1 -p  "── ${f} [o]pen [u]nstage [r]evert [a]dd [g]log [x|q]exit <ENTER>next: " op
		echo ''
		case "$op" in
			o) local diffsrc="$(mktemp)"
				(_git diff --cached --name-only -- "$f" | grep -q .) && gitopt=" --cached" || gitopt=""
				_git diff $gitopt -- "$f" > "$diffsrc"
				"$editor" -R "$diffsrc" -O "$f" -c 'wincmd l | setlocal noreadonly'
				rm -f "$diffsrc"
				;;
			u) _git restore --staged -- "$f" ;;
			r) _git restore -- "$f" ;;
			a) _git add -- "$f" ;;
			g) _git log --oneline -5 -- "$f" ;;
			x) exit 0 ;;
			*) break ;;
		esac
	done
}

while IFS= read -r file <&3; do
	[[ -n "$dir" && "$file" != *"$dir"* ]] && continue
	_act "$file"
done 3< "$modlist"

exit 0
