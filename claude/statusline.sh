#!/bin/sh
# Claude Code status line.
# - prints: [Model] ctx 32% · 5h 23% (↻14:30) · 7d 41%
# - saves the latest rate_limits to ~/.cache/claude-usage/rate_limits.json,
#   which the Herdr app's my-status mod (herdr-app/mods/my-status) shows.
# see also https://code.claude.com/docs/en/statusline

input=$(cat)

# rate_limits is only present for subscribers and after the first response.
cache_dir="$HOME/.cache/claude-usage"
limits=$(printf '%s' "$input" | jq -c '.rate_limits // empty | {five_hour, seven_day, updated_at: now | floor}' 2>/dev/null)
if [ -n "$limits" ]; then
  mkdir -p "$cache_dir"
  tmp=$(mktemp "$cache_dir/.rate_limits.XXXXXX")
  printf '%s\n' "$limits" > "$tmp" && mv "$tmp" "$cache_dir/rate_limits.json"
fi

printf '%s' "$input" | jq -r '
  def pct: if . == null then null else (. | round | tostring) + "%" end;
  def at(fmt): if . == null then "" else " (↻" + (. | localtime | strftime(fmt)) + ")" end;
  "[" + (.model.display_name // "Claude") + "] " + ([
    (.context_window.used_percentage | pct | if . then "ctx " + . else empty end),
    (.rate_limits.five_hour | if . and .used_percentage != null then "5h " + (.used_percentage | pct) + (.resets_at | at("%H:%M")) else empty end),
    (.rate_limits.seven_day | if . and .used_percentage != null then "7d " + (.used_percentage | pct) + (.resets_at | at("%m/%d")) else empty end)
  ] | join(" · "))
'
