<p align="center">
    <a href="https://www.getzola.org/">
        <img src="https://img.shields.io/badge/powered_by-Zola-brightgreen?style=flat-square&labelColor=202b2d&color=087e96" alt="Built with Zola"></a>
    <a href="https://github.com/welpo/tabi">
        <img src="https://img.shields.io/badge/theme-tabi-0?style=flat-square&labelColor=202b2d&color=087e96" alt="tabi theme"></a>
    <a href="https://welpo.github.io/tabi/blog/mastering-tabi-settings/">
        <img src="https://img.shields.io/badge/docs-here-0?style=flat-square&labelColor=202b2d&color=087e96" alt="Documentation"></a>
</p>

# tabi start

Start blogging in minutes with [Zola](https://www.getzola.org/) and [tabi](https://github.com/welpo/tabi).

![Screenshot of tabi theme](https://cdn.jsdelivr.net/gh/welpo/tabi@main/light_dark_screenshot.png)

## Quick start

1. On the top right of this page, click "Use this template" → "Create a new repository"
2. Replace placeholders in `content/_index.md` and in the first four lines of `config.toml`
3. Save your profile photo to `static/img/profile.webp` (or change the path to your image in `content/_index.md`)
4. Start writing in `content/blog/`. See `content/blog/hello.md` for an example

> [!TIP]
> Take a look through `config.toml` to customise further (set up [social links](https://welpo.github.io/tabi/blog/mastering-tabi-settings/#social-media-icons), your [email](https://welpo.github.io/tabi/blog/mastering-tabi-settings/#encoded-email)…). The [Mastering tabi Settings](https://welpo.github.io/tabi/blog/mastering-tabi-settings/) guide has more details.

## File structure

```tree
├── config.toml              # Site configuration
├── content/
│   ├── _index.md            # Home page
│   ├── archive/             # Archive page
│   │   └── _index.md        # Archive page section
│   ├── blog/                # Blog posts
│   │   ├── hello.md         # Sample post
│   │   └── _index.md        # Blog section configuration
│   └── projects/            # Projects page
│       ├── cool_project.md  # Sample project
│       └── _index.md        # Projects section configuration
│── static/
│   └── img/
│       └── profile.webp     # Profile photo for home page
└── themes/
    └── tabi/                # tabi theme
```

## Local development

1. [Install Zola](https://www.getzola.org/documentation/getting-started/installation/)
2. Clone your repository
3. Run `git submodule update --init --recursive`
4. Run `zola serve`
5. Visit http://127.0.0.1:1111. You should see [this](https://tabi-start.pages.dev/).

## Deployment

Refer to the [Zola documentation](https://www.getzola.org/documentation/deployment/overview/):

- [AWS S3 Bucket](https://www.getzola.org/documentation/deployment/aws-s3/)
- [Cloudflare Pages](https://www.getzola.org/documentation/deployment/cloudflare-pages/)
- [Codeberg Pages](https://www.getzola.org/documentation/deployment/codeberg-pages/)
- [Docker image](https://www.getzola.org/documentation/deployment/docker-image/)
- [Edgio](https://www.getzola.org/documentation/deployment/edgio/)
- [Fly.io](https://www.getzola.org/documentation/deployment/flyio/)
- [GitHub Pages](https://www.getzola.org/documentation/deployment/github-pages/)
- [GitLab Pages](https://www.getzola.org/documentation/deployment/gitlab-pages/)
- [Netlify](https://www.getzola.org/documentation/deployment/netlify/)
- [Sourcehut Pages](https://www.getzola.org/documentation/deployment/sourcehut/)
- [Vercel](https://www.getzola.org/documentation/deployment/vercel/)
- [Zeabur](https://www.getzola.org/documentation/deployment/zeabur/)

### Pre-compressed files

The publish workflow uploads brotli (quality 11) and zopfli gzip copies of every
text file to `_br/` and `_gz/` in the bucket, under the original paths and with
`Content-Encoding` set. The CloudFront Function in
[`cloudfront/precompressed.js`](cloudfront/precompressed.js) serves them,
based on the viewer's `Accept-Encoding`. It's attached to the distribution's
default behaviour as a viewer request function, and set up by hand:

```bash
aws cloudfront create-function --name precompressed \
  --function-config Comment="Serve pre-compressed copies",Runtime=cloudfront-js-2.0 \
  --function-code fileb://cloudfront/precompressed.js
aws cloudfront publish-function --name precompressed --if-match <ETag>
```

Then add it under *Function associations → Viewer request* in the default
behaviour. After changing the function, run `update-function` and
`publish-function` again. If the extension list changes, update
`COMPRESSIBLE` in both the function and `.github/workflows/publish.yml`.

Only attach the function once a deploy has uploaded `_br/` and `_gz/`;
otherwise it points every page at files that don't exist yet.

## Updating tabi

### Automated updates

This template includes a [GitHub Action workflow](https://github.com/welpo/tabi-start/blob/main/.github/workflows/update-tabi.yml) that checks for tabi theme updates weekly and creates a PR when updates are available.

#### Setting up permissions

The automated updates require proper GitHub Actions permissions:

1. Go to your repository's Settings → Actions → General
2. Scroll down to "Workflow permissions"
3. Enable "Allow GitHub Actions to create and approve pull requests"
4. Save changes

<details>
<summary>How automated updates work (click to read)</summary>

- Every Monday at midnight (UTC), the workflow checks for new tabi versions
- If an update is found, it creates a PR with:
  - Detailed changelog
  - Links to relevant commits and PRs
  - The exact changes being made
- It runs the Test build workflow. If the build fails, you'll receive an email notification. **Verify the site works locally before merging the PR**
- You can review and merge these updates at your convenience

</details>

### Manual updates

```bash
git submodule update --remote themes/tabi
```

## Support

- [tabi documentation](https://welpo.github.io/tabi/)
- [Zola documentation](https://www.getzola.org/documentation/getting-started/overview/)

> [!TIP]
> How was your experience with this template?
>
> Share your thoughts in this [tabi discussion](https://github.com/welpo/tabi/discussions/440) or [report any issues](https://github.com/welpo/tabi/issues/new?&labels=bug&template=2_bug_report.yml) you find! Thank you 🙇🏼‍♂️
