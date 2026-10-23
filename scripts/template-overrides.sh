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

# Template path (relative to templates/) and the sed edits applied to tabi's
# copy, one per line; each must still change tabi's file.
# The first two use a post's `[extra] lang` (e.g. "nl" for Dutch posts) for its
# language metadata, while the rest of the site stays in the default language.
OVERRIDES=(
    'base.html'
    's|<html lang="{{ lang }}"|<html lang="{{ page?.extra?.lang \| default(value=lang) }}"|'
    'atom.xml'
    's|<entry xml:lang="{{ page.lang }}">|<entry xml:lang="{{ page.extra.lang \| default(value=page.lang) }}">|'
    # The h-card links the same profile picture with a cache-busting hash;
    # without one here too, the home page downloads it twice.
    'partials/home_banner.html'
    's|get_url(path=header.img, trailing_slash=false)|get_url(path=header.img, trailing_slash=false, cachebust=true)|'
    # 1. tabi declares every favicon as a PNG; the site's is an SVG
    #    (img/profile.svg). Cache-busted like the banner and h-card, which use
    #    the same file.
    # 2. tabi loads the code highlighting stylesheet on every page; only load it
    #    on pages that have a highlighted code block.
    'partials/header.html'
    's|<link rel="icon" type="image/png" href="{{ get_url(path=config.extra.favicon) }}"/>|<link rel="icon" type="{% if config.extra.favicon is ending_with(pat=".svg") %}image/svg+xml{% else %}image/png{% endif %}" href="{{ get_url(path=config.extra.favicon, cachebust=true) }}"/>|
s|{%- set stylesheets = \[...stylesheets, "giallo.css"\] -%}|{%- if (page?.content \| default(value="")) is containing(pat="giallo z-code") or (section?.content \| default(value="")) is containing(pat="giallo z-code") -%}{%- set stylesheets = [...stylesheets, "giallo.css"] -%}{%- endif -%}|'
)

mode="${1:-check}"
status=0
for ((i = 0; i < ${#OVERRIDES[@]}; i += 2)); do
    file="${OVERRIDES[i]}" edits="${OVERRIDES[i + 1]}"
    theme="themes/tabi/templates/$file" site="templates/$file"

    sed_args=() stale=0
    while IFS= read -r edit; do
        if [ "$(sed -e "$edit" "$theme")" = "$(cat "$theme")" ]; then
            echo "$file: an edit no longer applies to tabi's template; update OVERRIDES: $edit" >&2
            stale=1
        fi
        sed_args+=(-e "$edit")
    done <<< "$edits"
    expected=$(sed "${sed_args[@]}" "$theme")

    if [ "$stale" = 1 ]; then
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
