+++
title = "Catching up with Zola and tabi"
date = "2026-10-22"
description = "tabi 5 came with a bunch of breaking changes, so updating it broke this site. Here's what it took to get it building again."

[taxonomies]
tags = ["Changelog"]
+++

I'm watching the [tabi](https://github.com/welpo/tabi) repository on GitHub, getting notification for "All activity". So I got quite excited to receive a notification saying there's a new major release: version 5. Although, with a bunch of breaking changes. But how bad can it be, really? I just didn't expect it would *actually* break anything for me. I figured, well, I don't do anything that fancy, how bad can it be?

So I applied the update, and everything broke. Zola couldn't build the site anymore. That made me look into it a bit more[^1], to update whatever needs updating to be compatible again, so I can keep pulling in the latest updates from tabi.

<!-- toc -->

## The updates

- [Zola](https://www.getzola.org/), from 0.20.0 to 0.23.6
- [tabi](https://github.com/welpo/tabi), to v5

The tabi updates come in through a GitHub action (I got it for free, with the Tabi start template), which opens a pull request whenever there's a new version. I usually just read the changelog out of interest, and then blindly click merge without checking any of the code. 99% of the time I don't really need to do anything.

Which I suppose is a flawed workflow, since the last couple of them got merged and then completely failed to deploy. Because apparently the pipeline had been broken for a long time, and I just never checked it..

## What broke

Zola 0.23 changed quite a lot, mostly because of its upgrade to Tera 2, the template engine [^2]. For this site, that meant:

- **Syntax highlighting**: Zola replaced its highlighter with [giallo](https://github.com/getzola/giallo). I picked the `catppuccin-frappe` theme, not because I have any idea what it is, but because that's what was in the Tabi upgrade guide (and it seems to look OK). 
- **Date formats**: from strftime patterns (`%d-%m-%Y`) to Unicode ones (`dd-MM-y`). 
- **Shortcodes**: tabi moved to Zola's new component syntax, so {% raw %}`{{ remote_text(…) }}` became `{{< remote_text … />}}`{% endraw %}.
- **Retired settings**: `subset_enabled` is now `enable_subset`, and `footnote_backlinks` and `add_src_to_code_block` are gone.
- **An old template override**: a copy of tabi's `header.html` in my own `templates/` folder, which replaced the theme's new version.

## Handing it over to Claude

I started on all of this manually, following the excellent [upgrade guide](https://welpo.github.io/tabi/blog/upgrading-to-zola-0-23/) that Óscar wrote on the tabi blog. But when I got to the date formats, I figured I'd quickly ask AI to do it, because I couldn't be bothered to look up what all of these codes mean. I'm not familiar enough with them to just write it from the top of my head, and it seemed like a quick thing to ask, instead of spending a while trying to figure it out.

That's when I noticed AI is actually pretty good at this entire codebase, and "understands" the migration. So I handed the whole thing to Claude, gave it the upgrade guide, and told it to implement whatever needs implementing, and to ask me when there's a decision to be made. Claude handled the rest of it, so it was relatively easy to deal with the migration and the breaking changes. It's a good example of "donkey work" as [Sparks](https://www.macsparky.com/) would say.

## Overrides, and giving back

I didn't quite remember what was in that old `header.html` override. It turned out to be two changes I'd made to tabi: an option to [turn off the font subset](https://github.com/welpo/tabi/pull/458), and [removing a `nofollow` tag](https://github.com/welpo/tabi/pull/465). I'd opened pull requests for both, and tabi accepted them since, so they've become part of the main theme. I didn't need the override anymore, so it's been cleaned up.

That's something I tend to do with the changes I implement. I make an exception in my own repository, one way or another, and at the same time I open a pull request to ask tabi to make it part of the theme. So if they accept my PR, at some point I can get rid of my exceptions, and just keep following the main theme. 

This round of changes produced a couple more of those PR's. The [banner image cache-busting](https://github.com/welpo/tabi/pull/725) has been merged already, and the [favicon type](https://github.com/welpo/tabi/pull/724), [escaped alt text](https://github.com/welpo/tabi/pull/723), [page language](https://github.com/welpo/tabi/pull/726), and [loading the highlighting CSS only where needed](https://github.com/welpo/tabi/pull/727) are still open. Out of which I'm not sure the [page language](https://github.com/welpo/tabi/pull/726) would even make sense for Tabi, that might just be a thing for me only, but it doesn't hurt to offer it.

## Keeping track of the overrides

That old `header.html` is a good example of what can go wrong with overrides. Zola uses my copy of a template instead of the theme's, so when tabi changes that template, I don't actually benefit from the changes. Nothing tells you, and I don't want to rely on my memory (it's definitely not reliable).

While working on these changes, I needed to override a couple of templates again. So I did some brainstorming with Claude, looking for better solutions.

Each override is now listed in a script, as the template and the edits to apply to tabi's version of it, one `sed` expression per edit. The script can do two things:

- `update` regenerates my copies from tabi's current templates, with the edits applied.
- `check` compares my copies with what `update` would produce, and fails when they differ. It also fails when an edit doesn't change anything anymore.

The `check` runs in the test build, which also runs on the automated tabi update pull requests, and as a [git-hook](https://github.com/Nizzlay/nizzlay.com/blob/main/.githooks/pre-commit). So when an update touches one of the overridden templates, the pull request fails, and shows me exactly which override needs attention. I could run `update`, to regenerate the file, or decide that the script needs updating as we no longer need to deal with an exception.

So now I can have the best of both worlds. Make exceptions when necessary, and then easily revert them and benefit from the community's updates to Tabi when I no longer need them.

```bash
{{< remote_text src="/scripts/template-overrides.sh" />}}
```

[^1]: Which I suppose is a good thing, as I haven't really posted anything new on here for ages.
[^2]: Scary changes, as the template engine (and the whole Go syntax) was one of the primary reasons I switched away from Hugo to Zola.
