#!/usr/bin/env bash
# Upload public/ to S3 and invalidate CloudFront, with the AWS CLI (preinstalled
# on GitHub's runners) instead of a third-party action, so there is no Node
# runtime to be deprecated. Run by .github/workflows/publish.yml after the build
# and pre-compress steps; needs BUCKET and DISTRIBUTION_ID, plus the usual AWS
# credentials and region.

set -euo pipefail
cd "$(dirname "$0")/.."

# Assets are either hash-busted by Zola (CSS/JS) or get a new filename when
# replaced, so they can be cached for a year. Everything else (HTML, feeds,
# robots.txt, the feed stylesheet…) keeps the same URL across deploys and
# gets a week, matched by whatever the first pass did not claim.
ASSETS=(js css svg ttf woff woff2 pdf png jpg jpeg JPG JPEG gif ico webp avif)
include=() exclude=()
for ext in "${ASSETS[@]}"; do
    include+=(--include "*.$ext")
    exclude+=(--exclude "*.$ext")
done

# Sync public/ (or one of its compressed copies) to the bucket, with
# both cache lifetimes; extra arguments are passed to both passes, last,
# because later --include/--exclude filters win.
# --exclude '*.DS_Store' keeps macOS junk out if public/ was built locally.
sync() {
    local src="$1" dest="$2"; shift 2
    aws s3 sync "$src" "$dest" --delete --no-progress \
        --exclude '*' "${include[@]}" \
        --cache-control 'max-age=31536000, public' "$@"
    aws s3 sync "$src" "$dest" --delete --no-progress \
        "${exclude[@]}" --exclude '*.DS_Store' \
        --cache-control 'max-age=604800, public' "$@"
}

# Compressed copies first, so the function never points at a copy
# that isn't there yet. Excluded paths are also kept out of --delete,
# so syncing the originals leaves _br/ and _gz/ alone, and syncing the
# copies leaves the uncompressed ones (see Pre-compress) alone.
for enc in br gz; do
    if [ "$enc" = br ]; then encoding=br; else encoding=gzip; fi
    skip=()
    while IFS= read -r f; do skip+=(--exclude "$f"); done < "uncompressed-$enc"
    sync "public/_$enc/" "s3://$BUCKET/_$enc" --content-encoding "$encoding" "${skip[@]}"

    while IFS= read -r f; do
        cache='max-age=604800, public'
        for ext in "${ASSETS[@]}"; do
            if [[ "$f" == *."$ext" ]]; then cache='max-age=31536000, public'; fi
        done
        aws s3 cp "public/_$enc/$f" "s3://$BUCKET/_$enc/$f" --no-progress --cache-control "$cache"
    done < "uncompressed-$enc"
done
sync public/ "s3://$BUCKET" --exclude '_br/*' --exclude '_gz/*'

aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*"
