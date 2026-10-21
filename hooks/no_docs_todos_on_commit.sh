#!/usr/bin/env bash
set -euo pipefail

# PreToolUse hook (Bash): reject `git commit` for a diff containing 'TODO(doc)'.

for tool in jq git realpath; do
  command -v -- "$tool" >/dev/null || { echo "$tool is required but not on PATH" >&2; exit 2; }
done

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
printf '%s' "$cmd" | grep -Eq '(^|[[:space:];&|(])git([[:space:]]+[^[:space:];&|]+)*[[:space:]]+commit([[:space:]]|$)' || exit 0

cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
[ -n "$cwd" ] || cwd=$PWD
root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || exit 0

# Commits to the guidelines repository itself are exempt.
repo=$(realpath -- "$(dirname -- "$(realpath -- "$0")")/..")
[ "$(realpath -- "$root")" = "$repo" ] && exit 0

# `git commit -a` (also as --all, or in a flag cluster such as -am) commits
# the work tree; every other form commits the index. Two forms are checked
# imprecisely: path arguments to `git commit` are ignored, and the diff is
# always taken in the session cwd, even for `git -C DIR commit`.
if printf '%s' "$cmd" | grep -Eq '(^|[[:space:]])(-[[:alnum:]]*a[[:alnum:]]*|--all)([[:space:]]|$)'; then
  changes=$(git -C "$cwd" diff HEAD -U0 --dst-prefix=b/)
else
  changes=$(git -C "$cwd" diff --cached -U0 --dst-prefix=b/)
fi

hits=$(printf '%s\n' "$changes" | awk '
  /^\+\+\+ / { file = substr($0, 7) }
  /^\+/ && !/^\+\+\+ / && /TODO\(doc\)/ { print "  " file ": " substr($0, 2) }')
[ -z "$hits" ] && exit 0

cat >&2 <<EOF
Commit refused: the changes still contain TODO(doc) markers.
Run the documentation skill to resolve them (rules/docs.md § Defer documenting).
$hits
EOF
exit 2
