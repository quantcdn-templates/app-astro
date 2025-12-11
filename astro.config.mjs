import { defineConfig } from 'astro/config';
import node from '@astrojs/node';

// https://astro.build/config
export default defineConfig({
  output: 'server',
  adapter: node({
    mode: 'standalone'
  }),
  server: {
    host: process.env.HOST || '0.0.0.0',
    port: parseInt(process.env.PORT) || 4321
  }
});
