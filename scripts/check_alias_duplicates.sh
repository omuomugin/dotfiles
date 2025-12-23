#!/bin/bash
set -euo pipefail

# Check for duplicate alias definitions in .aliases file

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
ALIASES_FILE="${DOTFILES_DIR}/.aliases"

if [ ! -f "$ALIASES_FILE" ]; then
  echo "Error: .aliases file not found at $ALIASES_FILE"
  exit 1
fi

echo "Checking for duplicate aliases in $ALIASES_FILE..."

# Extract all alias names from the file
# Match lines like: alias name='...' or alias name="..."
# Also match function names like: function name() or name()
aliases=$(grep -E "^alias [a-zA-Z0-9_-]+=" "$ALIASES_FILE" | sed -E "s/^alias ([a-zA-Z0-9_-]+)=.*/\1/" || true)
functions=$(grep -E "^(function [a-zA-Z0-9_-]+|^[a-zA-Z0-9_-]+\(\))" "$ALIASES_FILE" | sed -E "s/^function ([a-zA-Z0-9_-]+).*/\1/; s/^([a-zA-Z0-9_-]+)\(\).*/\1/" || true)

# Combine all names
all_names=$(echo -e "$aliases\n$functions" | sort)

# Find duplicates
duplicates=$(echo "$all_names" | uniq -d)

if [ -n "$duplicates" ]; then
  echo "❌ Found duplicate alias/function definitions:"
  echo "$duplicates" | while read -r name; do
    echo ""
    echo "Duplicate: $name"
    grep -n "^alias ${name}=" "$ALIASES_FILE" || true
    grep -n "^function ${name}" "$ALIASES_FILE" || true
    grep -n "^${name}()" "$ALIASES_FILE" || true
  done
  exit 1
else
  echo "✅ No duplicate aliases found"
  exit 0
fi
