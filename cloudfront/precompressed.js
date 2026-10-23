// CloudFront Function (viewer request, runtime cloudfront-js-2.0) that serves
// the brotli/gzip copies the publish workflow uploads to /_br/ and /_gz/
// (same paths and names as the originals, with Content-Encoding set).
//
// The S3 website origin can't choose between encodings, so this rewrites the
// URI based on the viewer's Accept-Encoding: brotli if accepted, else gzip,
// else the original. The rewritten URI is also the cache key, so each
// encoding is cached separately.
//
// Deployed by hand, see README.md ("Pre-compressed files").

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
