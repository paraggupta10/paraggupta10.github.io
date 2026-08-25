// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import mdx from '@astrojs/mdx';

// https://astro.build/config
export default defineConfig({
  site: 'https://paraggupta10.github.io',
  base: '/',
  trailingSlash: 'always',
  integrations: [sitemap(), mdx()],
});
