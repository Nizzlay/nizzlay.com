#!/usr/bin/env bash
# Site copies of tabi templates that need a small change, kept as "tabi's file
# plus a sed edit" so they can follow tabi updates:
#
#   scripts/template-overrides.sh check    fail if a copy differs from tabi + edit
#   scripts/template-overrides.sh update   regenerate the copies from tabi
#
# `check` runs in the test build, so a tabi update PR shows when a copy is out
# of date (or when tabi changed the line the edit applies to).

set -euo pipefail
cd "$(dirname "$0")/.."

# Template path (relative to templates/) and the sed edit applied to tabi's copy.
# Both use a post's `[extra] lang` (e.g. "nl" for Dutch posts) for its language
# metadata, while the rest of the site stays in the default language.
OVERRIDES=(
    'base.html'
    's|<html lang="{{ lang }}"|<html lang="{{ page?.extra?.lang \| default(value=lang) }}"|'
    'atom.xml'
    's|<entry xml:lang="{{ page.lang }}">|<entry xml:lang="{{ page.extra.lang \| default(value=page.lang) }}">|'
)

mode="${1:-check}"
status=0
for ((i = 0; i < ${#OVERRIDES[@]}; i += 2)); do
    file="${OVERRIDES[i]}" edit="${OVERRIDES[i + 1]}"
    theme="themes/tabi/templates/$file" site="templates/$file"
    expected=$(sed -e "$edit" "$theme")

    if [ "$expected" = "$(cat "$theme")" ]; then
        echo "$file: the edit no longer applies to tabi's template; update OVERRIDES" >&2
        status=1
    elif [ "$mode" = update ]; then
        mkdir -p "$(dirname "$site")"
        printf '%s\n' "$expected" > "$site"
        echo "$file: updated"
    elif ! diff -u --label "tabi + edit" --label "$site" <(printf '%s\n' "$expected") "$site"; then
        echo "$file: out of date; run scripts/template-overrides.sh update" >&2
        status=1
    fi
done
exit "$status"
