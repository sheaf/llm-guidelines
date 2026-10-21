#!/usr/bin/env bash
set -euo pipefail

# PreToolUse hook: ensure Claude never edits guideline files.

# Check required dependencies are available.
for tool in jq realpath; do
  command -v -- "$tool" >/dev/null || { echo "read_only_docs.sh: $tool is required but not on PATH" >&2; exit 2; }
done

repo=$(realpath -- "$(dirname -- "$(realpath -- "$0")")/..")
input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')
[ -z "$path" ] && exit 0
real=$(realpath -m -- "$path")
for root in "$repo" "$@"; do
  case "$real" in
    "$(realpath -m -- "$root")"/*)
      echo "Guidelines are read-only. Propose the change to the user instead. ($real)" >&2
      exit 2 ;;
  esac
done
exit 0
