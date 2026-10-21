#!/usr/bin/env bash
set -euo pipefail

for tool in jq realpath; do
  command -v -- "$tool" >/dev/null || { echo "install.sh: $tool is required but not on PATH" >&2; exit 1; }
done

repo=$(realpath -- "$(dirname -- "$(realpath -- "$0")")")
claude=${CLAUDE_HOME:-$HOME/.claude}
settings=$claude/settings.json

links=(
  "$repo/guidelines_root.md|$claude/CLAUDE.md"
  "$repo/rules|$claude/rules"
)
for skill in "$repo"/skills/*/; do
  links+=("${skill%/}|$claude/skills/$(basename -- "$skill")")
done

# Check all link paths before creating any links, to report all errors at once.
conflicts=()
for entry in "${links[@]}"; do
  target=${entry%%|*} name=${entry#*|}
  if [ -L "$name" ]; then
    [ "$(realpath -- "$name")" = "$(realpath -- "$target")" ] ||
      conflicts+=("$name already exists (symlink to $(readlink -- "$name"))")
  elif [ -e "$name" ]; then
    conflicts+=("$name already exists")
  fi
done
if [ "${#conflicts[@]}" -gt 0 ]; then
  echo "Nothing was installed, because of the following errors:" >&2
  printf '  %s\n' "${conflicts[@]}" >&2
  exit 1
fi

for entry in "${links[@]}"; do
  target=${entry%%|*} name=${entry#*|}
  [ -L "$name" ] && continue
  mkdir -p -- "$(dirname -- "$name")"
  ln -s -- "$target" "$name"
  echo "linked $name -> $target"
done

# Register the hooks, leaving the rest of settings.json alone.
[ -f "$settings" ] || echo '{}' > "$settings"
edit_settings() { # edit_settings JQ-ARGS...: rewrite settings.json through jq
  local tmp
  tmp=$(mktemp)
  jq "$@" "$settings" > "$tmp" && mv -- "$tmp" "$settings"
}
# Drop every hook from this repository first, so that a renamed or removed
# script does not stay registered.
edit_settings --arg prefix "bash $repo/hooks/" '
  .hooks.PreToolUse = ((.hooks.PreToolUse // [])
    | map(select((.hooks // []) | any(.command | startswith($prefix)) | not)))
'
register() { # register MATCHER SCRIPT
  edit_settings --arg matcher "$1" --arg cmd "bash $repo/hooks/$2" '
    .hooks.PreToolUse += [{matcher: $matcher, hooks: [{type: "command", command: $cmd}]}]
  '
  echo "registered $2 in $settings"
}
register "Edit|Write|MultiEdit|NotebookEdit" LLMs_do_not_edit_their_guidelines.sh
register "Bash"                              no_docs_todos_on_commit.sh
