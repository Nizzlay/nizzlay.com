+++
title = "Pre-compressed brotli and gzip"
date = "2026-10-26"
description = "CloudFront compressed this site on the fly, but not very well. Now every text file is compressed once, at the highest settings, when the site is built."

[taxonomies]
tags = ["Changelog"]
+++

Performance is important to me. At some point it turns into a bit of a vanity metric, still having theoretical value, not something you'd really notice, but I still like pursuing it. Page speed matters for SEO too, and there are plenty of studies showing that faster websites convert better. But that's not *that* relevant for a personal site on which I don't sell anything.

So this is mostly a technicality: serving every page, as small as it can get.

<!-- toc -->

## Why compress on the fly?

CloudFront, which serves this site, compressed files on the fly. But it wasn't perfect. It only ever served gzip, never brotli (not sure if it should, or I needed to tweak settings), only for files above a certain size, and with a compression preference that prioritises speed of compression over filesize. So some files weren't compressed at all, and the others not as much as they could have been.

And for a static site, compressing every response on request doesn't make much sense anyway. The files only change when I deploy. Compressing them once, during the build, also allows the highest settings, which would be too slow to do on the fly: brotli at quality 11, and gzip at 9 with zopfli.

## How it works

1. During the build, CI creates a brotli and a gzip copy of every text file: HTML, CSS, JavaScript, SVG, XML, and so on.
2. The copies are uploaded to `_br/` and `_gz/` in the S3 bucket, under the same paths as the originals, with the right `Content-Encoding`.
3. A CloudFront Function looks at the browser's `Accept-Encoding` header, and picks the copy it can handle. The URL in the browser stays the same.

CloudFront's own compression is still on as a fallback. I could probably get rid of that though. In theory, turning it off might save some picoseconds, when CloudFront doesn't have to check at all.

This is the step in the GitHub Actions workflow that makes the copies:

```yaml
- name: Pre-compress
  run: |
    sudo apt-get install -y --no-install-recommends brotli zopfli > /dev/null
    COMPRESSIBLE=(html css js mjs json xml xsl txt svg ico ttf webmanifest map)
    match=()
    for ext in "${COMPRESSIBLE[@]}"; do match+=(-o -iname "*.$ext"); done

    cd public
    find . -type f \( "${match[@]:1}" \) -printf '%P\0' > ../compressible
    # Tiny files can come out bigger when compressed. Their copy then holds
    # the original bytes instead, listed in ../uncompressed-br or -gz so the
    # deploy uploads it without Content-Encoding. The function still finds
    # a copy at the expected path; it's just not compressed.
    : > ../uncompressed-br; : > ../uncompressed-gz
    xargs -0 -P "$(nproc)" -n 1 sh -c '
      mkdir -p "_br/$(dirname "$1")" "_gz/$(dirname "$1")"
      brotli --quality=11 --lgwin=24 --stdout -- "$1" > "_br/$1"
      zopfli -c -- "$1" > "_gz/$1"
      for enc in br gz; do
        if [ "$(wc -c < "_$enc/$1")" -ge "$(wc -c < "$1")" ]; then
          cp -- "$1" "_$enc/$1"
          echo "$1" >> "../uncompressed-$enc"
        fi
      done
    ' sh < ../compressible
```

And this is the CloudFront Function. It runs on every request, before CloudFront looks in its cache, and rewrites the path to the right copy:

```js
// Must match COMPRESSIBLE in .github/workflows/publish.yml: every file with
// one of these extensions has a copy in /_br/ and /_gz/.
var COMPRESSIBLE = {
    html: true, css: true, js: true, mjs: true, json: true, xml: true, xsl: true,
    txt: true, svg: true, ico: true, ttf: true, webmanifest: true, map: true,
};

// Whether the Accept-Encoding header allows `coding` (not absent, not q=0).
function accepts(header, coding) {
    var parts = header.toLowerCase().split(',');
    for (var i = 0; i < parts.length; i++) {
        var params = parts[i].trim().split(';');
        if (params[0].trim() !== coding) continue;
        for (var j = 1; j < params.length; j++) {
            var q = params[j].trim();
            if (q.indexOf('q=') === 0 && parseFloat(q.slice(2)) === 0) return false;
        }
        return true;
    }
    return false;
}

function handler(event) {
    var request = event.request;
    var header = request.headers['accept-encoding'];
    if (!header) return request;

    var uri = request.uri;
    // Directory URLs are served from their index.html, like the S3 website
    // endpoint does. URLs without a trailing slash or extension are left for
    // S3 to redirect to the trailing-slash version.
    if (uri.slice(-1) === '/') uri += 'index.html';
    var name = uri.slice(uri.lastIndexOf('/') + 1);
    var dot = name.lastIndexOf('.');
    if (dot < 1 || !COMPRESSIBLE[name.slice(dot + 1).toLowerCase()]) return request;

    if (accepts(header.value, 'br')) request.uri = '/_br' + uri;
    else if (accepts(header.value, 'gzip')) request.uri = '/_gz' + uri;
    return request;
}
```

Because the rewritten path is also what CloudFront caches on, each encoding is cached separately. Both files are on GitHub: [the workflow](https://github.com/Nizzlay/nizzlay.com/blob/b71fcd1/.github/workflows/publish.yml) and [the function](https://github.com/Nizzlay/nizzlay.com/blob/b71fcd1/cloudfront/precompressed.js).

## Smaller, or not at all

We shouldn't be stubborn about it. The goal is to speed up loading times by serving smaller files. For tiny files (such as a `robots.txt`), compression can add more overhead than it saves. In that case it makes no sense to use it, so a copy that isn't smaller gets tossed, and is served without compression.

Never underestimate the overhead of things. Especially on a simple website like this one.

## Why not zstd?

I tried it, at its maximum level, but brotli compresses better. zstd is a lot faster at compressing, which is nice when you do it on the fly. But when it happens once during the build, that's simply not relevant. We only need to focus on the filesize results.

## Why not images?

Images are already compressed, so brotli and gzip barely help them. At least, as far as I know. Feel free to [educate me](@/pages/hello.md) if I'm missing something here!

## The results

{% <wide_container> %}
| Page | Uncompressed | On the fly (gzip) | Pre-compressed (brotli) | Change |
|---|--:|--:|--:|--:|
| [Automatically cancelling duplicate projects in Things](@/blog/automatically-cancelling-duplicate-projects-things3.md) | 29.1 KB | 6.6 KB | 5.5 KB | −17% |
| [Uses](@/pages/uses.md) | 16.2 KB | 6.3 KB | 5.2 KB | −17% |
| [Tempted by the Tux](@/blog/tempted-by-the-tux.md) | 14.7 KB | 5.6 KB | 4.6 KB | −18% |
| [De meerwaarde van Twitter](@/blog/de-meerwaarde-van-twitter.md) | 24.2 KB | 8.8 KB | 7.8 KB | −11% |
| [Blog Questions Challenge](@/blog/blog-questions-challenge.md) | 18.1 KB | 5.4 KB | 4.5 KB | −17% |
{% </wide_container> %}

And the stylesheet, which every page loads: from 13.1 KB with gzip to 11.3 KB with brotli (−14%).

The "on the fly" column is gzip at its default level 6, which is what CloudFront used to do. "Pre-compressed" is the brotli copy, with compression turned up to 11, which is what every modern browser gets now.

Around a kilobyte less per page. Not a lot, but it's free: it happens once during the build, and costs visitors nothing.
