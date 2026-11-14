+++
title = "Post dates that update themselves"
date = "2026-10-23"
description = "Keeping the \"Last updated\" date of a post accurate is one of those chores that isn't worth doing by hand. So now a git hook does it for me."

[taxonomies]
tags = ["Changelog", "Automation"]
+++

tabi, the theme I'm using, shows a "Last updated" line under a post's title, when the post has an `updated` date in the frontmatter. Which I never set. Not by hand, and not at all. It feels like one of those chores that just isn't worth doing manually: lots of hassle, little value.

But if it can be automated, why not?

<!-- toc -->

## The hook

I think tabi's documentation links to [this post on osc.garden](https://osc.garden/blog/zola-date-git-hook/) *somewhere*. Its author, Óscar, is the same guy who made the tabi theme. It describes a pre-commit hook that sets the `updated` date of every post that changes in a commit, so the "Last updated" line stays accurate without me having to think about it.

I had it on my list to set up for a while, I just never got around to it. Now with AI, that barrier is gone.

The hook lives in the repository, in [`.githooks/`](https://github.com/Nizzlay/nizzlay.com/tree/main/.githooks).

## What I changed

A few things are different from the original:

- **The date format.** It writes dates in this site's front matter style: `date = "YYYY-MM-DD"`.
- **Plain old bash.** Although I use the Fish shell, Claude made sure the hook runs with the bash that macOS ships, so without any bash 4 features. Reducing dependencies.
- **Only real edits count.** Only posts that I edited get a new date, not posts that are new. And since the hook also [compresses images](@/blog/compressing-images-on-commit.md) and [rewrites them to AVIF and WebP](@/blog/avif-and-webp-only-when-it-helps.md), a post that only had its images converted by the hook doesn't count as updated either.

The date itself is the day the file was last modified. A post that's edited on the day it was published (which is usually the moment you're in a panic to fix typo's seconds after publishing) doesn't get an `updated` date at all.

This is the part of the hook that does it:

```bash
# Posts edited in this commit (modified, not newly added; no section indexes),
# collected before the image steps below rewrite any posts, so a post that only
# had its images converted doesn't get a new `updated` date.
staged=$(git diff --cached --name-only --diff-filter=M -- '*.md' ':(exclude)*_index.md')

# … the image steps …

[ -n "$staged" ] || exit 0

while IFS= read -r file; do
    [ -n "$file" ] && [ -f "$file" ] || continue

    # Only posts carry a `date`; pages without one are left alone.
    date_line=$(grep -m 1 '^date = ' "$file") || continue

    unquote() { sed -e 's/^[a-z]* = //' -e 's/[[:space:]]*$//' -e 's/^"//' -e 's/"$//'; }
    published=$(printf '%s\n' "$date_line" | unquote)
    last_modified=$(date -r "$file" +'%Y-%m-%d')

    # A post edited on the day it was published needs no `updated` field.
    [ "$published" = "$last_modified" ] && continue

    updated_line=$(grep -m 1 '^updated = ' "$file")
    if [ -n "$updated_line" ]; then
        # Already correct: leave the file (and the index) untouched.
        [ "$(printf '%s\n' "$updated_line" | unquote)" = "$last_modified" ] && continue
    fi

    # Match the quoting style of the file's own `date` field.
    case "$date_line" in
        *'"'*) new_value="\"$last_modified\"" ;;
        *)     new_value="$last_modified" ;;
    esac

    if [ -n "$updated_line" ]; then
        # Replace the existing field.
        awk -v v="$new_value" '
            BEGIN { done = 0 }
            /^updated = / && !done { print "updated = " v; done = 1; next }
            { print }
        ' "$file" > "$file.tmp" || error_exit "failed to rewrite $file"
    else
        # Add it directly below `date`.
        awk -v v="$new_value" '
            BEGIN { done = 0 }
            { print }
            /^date = / && !done { print "updated = " v; done = 1 }
        ' "$file" > "$file.tmp" || error_exit "failed to rewrite $file"
    fi

    mv "$file.tmp" "$file" || error_exit "failed to replace $file"
    git add -- "$file"
    echo "pre-commit: updated = $last_modified in $file"
done <<< "$staged"
```

The [whole hook](https://github.com/Nizzlay/nizzlay.com/blob/196dcbb/.githooks/pre-commit) is on GitHub.

## What counts as an update?

Does fixing a typo deserve a new date? For me, it doesn't really matter. I don't do (and never will do) breaking news or live blogs, nothing time sensitive [^1], so my updates will mostly boil down to fixing typos. Which is exactly why it isn't worth the effort of doing by hand: too much work for too little value. But if it can be automated, it's a nice to have.

Anyone who really wanted to know what changed could already find it in Git, but now it's just a bit nicer.

[^1]: I don't envy the journalists that live in those kinds of environments, it seems absolutely horrible to me.
