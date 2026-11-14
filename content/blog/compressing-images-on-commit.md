+++
title = "Compressing images on commit"
date = "2026-10-24"
description = "Compressing images is important, but it's also easy to forget. So now a git hook does it for me, every time I commit an image."

[taxonomies]
tags = ["Changelog", "Automation"]
+++

Since I was working on git hooks anyway, I figured let's automate another chore while I was at it. One that I feel is important, but that's also easy to forget: compressing images.

<!-- toc -->

## ImageOptim, from the command line

I've been using [ImageOptim](https://imageoptim.com/mac) since forever. Not since my very first website (not sure if it already existed that long ago), but definitely since I learned more about site speed and SEO. When I started building websites for customers, either in my day job or as a side hustle, ImageOptim was always part of it. Manually, by dragging a bunch of files into the app. Whenever I remembered to do it.

The idea came from [this post on osc.garden](https://osc.garden/blog/zola-date-git-hook/). Its hook compresses PNGs as well, with oxipng and optipng. But since I already had ImageOptim installed, my hook uses that:

- **PNG**: pngquant, then oxipng
- **JPEG**: jpegoptim
- **SVG**: svgcleaner
- **WebP**: cwebp, which isn't part of ImageOptim, so I installed it with Homebrew

Only the images in a commit are compressed, so it only costs time when I add or change one. And if one of the tools is missing, the hook commits the image uncompressed and tells me, instead of blocking the commit.

## Lossy, at 80%

- **PNG**: pngquant at a quality of 65–80. If the result isn't smaller, the original is kept. Then oxipng squeezes out whatever is left, without losing anything.
- **JPEG**: jpegoptim at a maximum quality of 80, with the metadata stripped, saved as a progressive JPEG.
- **WebP**: cwebp at a quality of 80. Again, only kept if it's smaller.

Why lossy? Because for my kind of content, the images don't matter that much (I have plenty of posts without any images at all). It's not as if I'm an artist or a photographer who wants to show off their skills. Losing some detail is perfectly fine for me.

I did compare a couple of images side by side, but I honestly don't see the difference. Which might just be me, as I'm not great at spotting these kinds of nuances. At work I'm the same when discussing designs with our designer: quite often I'll just admit I have no idea what the difference is, and we'll go with whatever they think is best. 😅

## The hook

Pre-commit hook, so it can never be forgotten again. It takes the images that are added or changed in the commit, runs each one through the right tool, and adds the compressed version to the commit if it's smaller.

```bash
imageoptim_bin=/Applications/ImageOptim.app/Contents/Frameworks/ImageOptimGPL.framework/Versions/A/Resources

# ImageOptim has no WebP support, so WebP goes through cwebp from libwebp
# (`brew install webp`). Git GUIs may not have Homebrew on the PATH.
cwebp_bin=$(command -v cwebp || echo /opt/homebrew/bin/cwebp)

# Keep $2 in place of $1 if it exists and is smaller; otherwise discard it.
keep_if_smaller() {
    if [ -s "$2" ] && [ "$(wc -c < "$2")" -lt "$(wc -c < "$1")" ]; then
        mv -- "$2" "$1"
    else
        rm -f -- "$2"
    fi
}

# Added or modified images. Already-compressed files come out (nearly) unchanged,
# so re-running on them is harmless.
images=$(git diff --cached --name-only --diff-filter=AM -- \
    ':(icase)*.png' ':(icase)*.jpg' ':(icase)*.jpeg' ':(icase)*.svg' ':(icase)*.webp')

while IFS= read -r file; do
    [ -n "$file" ] && [ -f "$file" ] || continue
    before=$(wc -c < "$file" | tr -d ' ')

    case "$file" in
        *.[Ww][Ee][Bb][Pp]) tool="$cwebp_bin" ;;
        *)                  tool="$imageoptim_bin/pngquant" ;;
    esac
    if [ ! -x "$tool" ]; then
        echo "pre-commit: $(basename "$tool") not found, committing $file uncompressed" >&2
        continue
    fi

    case "$file" in
        *.[Pp][Nn][Gg])
            # Exit 98/99 mean pngquant kept the original (no gain, or
            # quality would drop below 65); oxipng still runs losslessly.
            "$imageoptim_bin/pngquant" --quality=65-80 --skip-if-larger \
                --strip --force --ext .png -- "$file"
            case $? in 0|98|99) ;; *) error_exit "pngquant failed on $file" ;; esac
            "$imageoptim_bin/oxipng" -q -o 4 --strip safe -- "$file" \
                || error_exit "oxipng failed on $file"
            ;;
        *.[Ss][Vv][Gg])
            # svgcleaner exits 0 even on errors, and writes nothing when the
            # result would be bigger, so only a smaller output file is kept.
            # Its output name must end in .svg.
            "$imageoptim_bin/svgcleaner" --quiet "$file" "$file.tmp.svg" 2>/dev/null
            keep_if_smaller "$file" "$file.tmp.svg"
            ;;
        *.[Ww][Ee][Bb][Pp])
            # Re-encodes lossy; animated WebP isn't supported and is left as is.
            if ! "$cwebp_bin" -quiet -q 80 -m 6 -metadata none "$file" -o "$file.tmp" 2>/dev/null; then
                echo "pre-commit: cwebp could not process $file, committing it uncompressed" >&2
            fi
            keep_if_smaller "$file" "$file.tmp"
            ;;
        *)
            "$imageoptim_bin/jpegoptim" -q --max=80 --strip-all \
                --all-progressive -- "$file" \
                || error_exit "jpegoptim failed on $file"
            ;;
    esac

    after=$(wc -c < "$file" | tr -d ' ')
    if [ "$after" -lt "$before" ]; then
        git add -- "$file"
        echo "pre-commit: compressed $file ($before -> $after bytes)"
    fi
done <<< "$images"
```

The [whole hook](https://github.com/Nizzlay/nizzlay.com/blob/a7d35d3/.githooks/pre-commit), is on GitHub.

## The existing images

I most likely did run ImageOptim by hand at some point for most of the images that were already on the site. But a final pass doesn't hurt (At least I think compressing already compressed images doesn't do anything), so I ran the hook over everything in `static/` once:

| Image | Before | After | Change |
|---|--:|--:|--:|
| `cron-cancel-duplicates-things3.png` | 12.1 KB | 8.5 KB | −30% |
| `enable-things-urls.png` | 25.3 KB | 14.1 KB | −44% |
| `external-monitor.png` | 3.3 KB | 1.7 KB | −48% |
| `img/profile.webp` | 8.4 KB | 7.6 KB | −10% |
| `zapier-buffer-twitter.png` | 20.0 KB | 15.5 KB | −22% |
| **Total** | **69.1 KB** | **47.3 KB** | **−31%** |

Not a lot of kilobytes in total, but almost a third less. And more importantly: from now on, I can't forget it anymore.
