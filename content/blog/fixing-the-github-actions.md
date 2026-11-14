+++
title = "Fixing the GitHub Actions"
date = "2026-10-21"
description = "My GitHub Actions had been failing for months without me noticing, so I fixed them, dropped a dependency, and finally got proper cache headers."

[taxonomies]
tags = ["Changelog"]
+++

Normally every week or so, GitHub sends me an email saying that there's a new version of tabi (the theme on this site). That's an action running on a schedule, opening a pull request whenever there's an update.

I hadn't received those emails in a while. Partially that's down to Apple's Mail app being an unreliable mess with its rules[^1], but I could also have been that there simply weren't any updates.

When I randomly logged into GitHub, and noticed a pile of pending pull requests. And in the actions, every single run was failing. It was about time to dig a bit further.

<!-- toc -->

## Deprecated Node versions

The workflows didn't run, because the actions they use depended on versions of Node that GitHub no longer supports[^2]. Apparently it hadn't supported them for many months already, but I didn't check it for a while. Bumping `actions/checkout` from v4 to v7, and Zola to the latest version in both workflows, got things going again (although, that did [break my website](@/blog/catching-up-with-zola-and-tabi.md), but at least the pipeline ran).

It was a bit strange to me on how Github would expect you to find out about these things. It's clearly one of those things that I would spend time thinking about as a product manager, whenever you introduce anything you think about what to do with migrations and informing users. GitHub deprecates a dependency that I suppose loads of actions depend on, including those in my repository. And the only way of knowing is looking at the actions. There's a news article about it, sure, but you would expect that with a major deprecation like that, you'd get an email of some sort:

> Hey, your actions keep failing, and it's because they depend on a version we no longer support. Here's the news article.

Maybe it's my settings or preferences somewhere. Either way, nothing proactively reached out to me, so I missed it, and I was months behind on maintenance (clearly, it's not my dayjob 😂).

## Replacing the S3 deploy action

The deploy used a third-party action, [`reggionick/s3-deploy`](https://github.com/reggionick/s3-deploy), with its own Node runtime. My first instinct was to look for a newer version of it. I simply don't know much about actions, and assumed I needed it.

But Claude pointed out that the action runs on an Ubuntu runner, which already has the AWS CLI installed. So the dependency isn't strictly necessary at all. I tend to prefer not having a dependency, so that was an easy decision: drop it, and just use the CLI.

I might have leaned differently a couple of years ago, if I'd had to do all of this manually myself. Hoping the third-party action would make it simpler. Now, with AI assisting in these kinds of changes, it's an easy choice to just throw it over to Claude and let it figure it out[^3]. 

It also means there's no Node runtime left that can be deprecated, so less prone to breaking again in the future I suppose. 

## Better cache headers

The deploy action set the same `Cache-Control` header for everything: a week. These `Expires` headers were something I had on my other websites where I was using Hugo. I wanted to set them up when this site went live, but I couldn't figure out how with Zola and the GitHub deploy action. I think the documentation I checked at the time only showed a generic `Cache-Control`, nothing that could be defined per filetype.

Now that the deploy is being rebuilt using the CLI anyway, it was a good opportunity to finally implement it. Something I wanted years ago, when I first built this site. 

The upload now happens in two passes:

- **Assets** (CSS, JavaScript, images, fonts, PDFs) are cached for a year. Zola adds a hash to the CSS and JavaScript URLs when they change, and a replaced image gets a new filename, so they never go stale.
- **Everything else** (HTML, feeds, `robots.txt`) keeps the same URL across deploys, that's cached for a week.

This makes the website ridiculously fast to navigate. Going back to any page you visited before is literally instant, and would probably work even without an internet connection.

```bash
{{< remote_text src="/scripts/deploy.sh" />}}
```

[^1]: Seriously. Advanced stuff like forwarding some emails basically always fails (100% if they include attachments). And even basic things like moving some emails to specific folders will depend on however the stars are aligned at the time of processing.

[^2]: Really, this is a great argument to just use a compiled language for everything. Having to maintain compatability with versioned runtimes is a chore we can happily do without.

[^3]: In this case I've used the AWS CLI plenty of times myself, so I would have probably figured it out, but having Claude do it was significantly easier.
