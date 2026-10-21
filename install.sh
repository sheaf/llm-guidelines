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

# Register the hook, leaving the rest of settings.json alone.
hook="bash $repo/hooks/read_only_docs.sh"
[ -f "$settings" ] || echo '{}' > "$settings"
tmp=$(mktemp)
jq --arg cmd "$hook" '
  .hooks.PreToolUse = ((.hooks.PreToolUse // [])
    | map(select((.hooks // []) | any(.command == $cmd) | not))
    + [{matcher: "Edit|Write|MultiEdit|NotebookEdit",
        hooks: [{type: "command", command: $cmd}]}])
' "$settings" > "$tmp" && mv -- "$tmp" "$settings"
echo "registered hook in $settings"
