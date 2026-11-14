+++
title = "AVIF and WebP, only when it helps"
date = "2026-10-25"
description = "Compression only gets you so far. So my images now come in AVIF and WebP too, but only when they're actually worth it."

[taxonomies]
tags = ["Changelog", "Automation"]
+++

Compression only gets you so far. Now that every image is [compressed when I commit them](@/blog/compressing-images-on-commit.md), the next step is a different format altogether. AVIF and WebP *can* make the same image a lot smaller than a PNG or JPEG. Can, because it turns out they haven't actually gone to wizard school 🤷‍♂️.

<!-- toc -->

## A fallback that's been around for years

The `<picture>` element has a `<source>` for every format, and the original PNG or JPEG in an `<img>` as the fallback:

```html
<picture>
    <source type="image/avif" srcset="/foo.avif">
    <source type="image/webp" srcset="/foo.webp">
    <img src="/foo.png" alt="…">
</picture>
```

The browser uses the first source it supports, and skips the rest. Which means the order matters: the smallest file has to come first.

I've known about this HTML for ages. I just never did any of it, as it seemed like a lot of work. Creating every image in three formats, and writing all that HTML, for every image. Unless, of course, *something* does that for me.

## Generate, compress, then decide

The pre-commit hook does this in three steps for every PNG and JPEG I commit:

1. **Generate** an AVIF and a WebP version from the original.
2. **Compress** The new formats are made from the originals, before compression, so they're not affected by the lossy compression throwing away some details.
3. **Decide** which versions are worth keeping, and delete the rest. New formats aren't magic: sometimes they're not worth keeping.

A version is only kept when it's at least 512 bytes smaller than the next file in line. A WebP has to beat the original, and an AVIF has to beat the WebP as well to earn its keep. That way the order AVIF, WebP, original is always smallest first.

Why 512 bytes? Because every version adds some HTML to the page, and the saving needs to be worth that overhead. In theory I could probably count the exact number of bytes, but half a kilobyte seemed like a reasonable guesstimate.

And when I delete an image, its versions go with it, so nothing is left behind.

These are the two functions that do the generating and the deciding. In between, the original is compressed.

```bash
# A WebP/AVIF version is only kept if it saves at least this many bytes over
# the next file in line.
min_saving=512

# Step 1: write foo.tmp.webp and foo.tmp.avif for the PNG or JPEG $1.
encode_variants() {
    local file="$1" stem="${1%.*}"
    if [ -x "$cwebp_bin" ]; then
        "$cwebp_bin" -quiet -q 80 -m 6 -metadata none "$file" -o "$stem.tmp.webp" 2>/dev/null
    else
        echo "pre-commit: cwebp not found, skipping WebP for $file" >&2
    fi
    if [ -x "$avifenc_bin" ]; then
        "$avifenc_bin" -q 80 -s 4 --ignore-exif --ignore-xmp \
            "$file" "$stem.tmp.avif" >/dev/null 2>&1
    else
        echo "pre-commit: avifenc not found, skipping AVIF for $file" >&2
    fi
}

# Step 3: keep WebP only if it's at least $min_saving bytes smaller than the
# compressed original $1, and AVIF only if it's that much smaller than both.
keep_variants() {
    local file="$1" stem="${1%.*}" ext variant tmp
    local limit=$(wc -c < "$1")
    for ext in webp avif; do
        variant="$stem.$ext"
        tmp="$stem.tmp.$ext"
        if [ -s "$tmp" ] && [ $((limit - $(wc -c < "$tmp"))) -ge "$min_saving" ]; then
            mv -- "$tmp" "$variant"
            limit=$(wc -c < "$variant")
            git add -- "$variant"
            echo "pre-commit: created $variant ($(echo $limit) bytes)"
        else
            rm -f -- "$tmp"
            if [ -e "$variant" ]; then
                git rm -q --cached --ignore-unmatch -- "$variant"
                rm -f -- "$variant"
                echo "pre-commit: removed $variant (saves less than $min_saving bytes)"
            fi
        fi
    done
}
```

The [whole hook](https://github.com/Nizzlay/nizzlay.com/blob/196dcbb/.githooks/pre-commit) is on GitHub, including the part that rewrites the Markdown, and the [`image` component](https://github.com/Nizzlay/nizzlay.com/blob/196dcbb/templates/components/image.html) that outputs the `<picture>` element.

## I only write Markdown

I don't want to change my workflow in any way. I don't want to have to think about these things. I should only have to think about the content itself (which is hard enough). Which format is the smallest is a technicality, and the automation needs to take care of it. 

I write markdown. Images are `![alt](image.png)`, as always. When the hook keeps a smaller version, it rewrites that line to the `image` component, which outputs the `<picture>` element. It leaves code blocks alone, and skips posts with changes that aren't staged.

## The results

20 of the 40 PNGs and JPEGs on the site got a smaller version. For the other 20, the original stayed the smallest (or close enough that it's not worth the overhead).

| Image | Original | Served | Format | Change |
|---|--:|--:|---|--:|
| `1keyboard.png` | 75.1 KB | 24.4 KB | WebP | −68% |
| `IMG_1707-klein.jpeg` | 17.1 KB | 13.3 KB | WebP | −22% |
| `IMG_1708-klein.jpeg` | 14.2 KB | 10.6 KB | WebP | −25% |
| `LVCC.jpg` | 246.3 KB | 170.4 KB | WebP | −31% |
| `OmniFocus-2-Compacte-Layout.png` | 15.5 KB | 9.4 KB | WebP | −39% |
| `Referentie-voor-OmniFocus.png` | 25.8 KB | 23.0 KB | WebP | −11% |
| `backlog-refinement.png` | 25.8 KB | 13.3 KB | WebP | −49% |
| `bodytech.jpg` | 18.0 KB | 11.1 KB | WebP | −39% |
| `enable-things-urls.png` | 14.1 KB | 13.5 KB | AVIF | −4% |
| `eradiator.jpeg` | 11.7 KB | 7.1 KB | WebP | −39% |
| `fietsen-in-sneeuw.jpg` | 29.4 KB | 21.4 KB | WebP | −27% |
| `gaten-boren-door-scan.jpg` | 22.3 KB | 12.4 KB | WebP | −44% |
| `gescande-stekkerdoos.jpg` | 10.4 KB | 4.2 KB | WebP | −60% |
| `gitlab-development-board.png` | 22.6 KB | 11.1 KB | WebP | −51% |
| `gitlab-planning-board.png` | 24.4 KB | 11.0 KB | WebP | −55% |
| `hazel-omnifocus-referentie.png` | 23.3 KB | 21.9 KB | WebP | −6% |
| `homescreen-2012.png` | 276.7 KB | 118.5 KB | WebP | −57% |
| `tweetbot-filters.png` | 35.6 KB | 24.3 KB | WebP | −32% |
| `velgremmen-tiewrap.jpg` | 9.6 KB | 6.3 KB | WebP | −34% |
| `verpakking-hersluiten.jpg` | 67.5 KB | 63.9 KB | WebP | −5% |
| **Total** | **985.5 KB** | **591.1 KB** | | **−40%** |

We tend to think that everything newer is better. I mean, why else would it have been invented? But as with everything, nuance is important. Half of the images stayed in their original format. And AVIF, the newest of the bunch, won only once. Just barely: 531 bytes smaller than the PNG, only just over the threshold. For every other image, WebP was smaller, or AVIF didn't save enough on top of it.

Sadly new formats are not magic, and we can't simply blindly replace all images.
