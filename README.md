# paraggupta10.github.io

Personal portfolio site for Parag Gupta (DevOps Engineer / Site Reliability
Engineer), built with [Astro](https://astro.build). Single-page homepage
(intro, about, experience, skills, projects, achievements, blog teaser,
contact) plus a full blog section backed by Astro content collections.

Live at [https://paraggupta10.github.io/](https://paraggupta10.github.io/).

## Tech stack

- Astro (content collections, `@astrojs/sitemap`, `@astrojs/mdx`, `@astrojs/rss`)
- Plain scoped/global CSS — no CSS framework
- Deployed as a GitHub Pages **user site** via GitHub Actions

## Local development

```sh
npm install
npm run dev       # http://localhost:4321/
npm run build     # outputs to ./dist
npm run preview   # preview the production build
```

## Project structure

```text
/
├── public/                  static assets served as-is
│   ├── llms.txt              agent/LLM-friendly site summary
│   ├── robots.txt             explicitly allows GPTBot/ClaudeBot/PerplexityBot/etc.
│   ├── resume.json            JSON Resume (jsonresume.org) structured data
│   ├── resume.pdf              downloadable resume
│   └── profile.jpg             hero photo
├── src/
│   ├── content/blog/         blog posts (Markdown + frontmatter)
│   ├── content.config.ts      content collection schema
│   ├── components/            homepage section components
│   ├── layouts/BaseLayout.astro  shared <head>, SEO tags, Person JSON-LD
│   └── pages/
│       ├── index.astro        homepage (single scrolling page)
│       ├── blog/index.astro   full post listing
│       ├── blog/[slug].astro  individual post page
│       └── rss.xml.js          RSS feed
└── .github/workflows/deploy.yml  GitHub Pages deploy workflow
```

## Deployment

GitHub Pages user-site deployment is configured in
`.github/workflows/deploy.yml` using `actions/deploy-pages`, triggered on
every push to `master`. `astro.config.mjs` sets
`site: 'https://paraggupta10.github.io'` and `base: '/'` to match.

## License

MIT — see [LICENSE](./LICENSE).
