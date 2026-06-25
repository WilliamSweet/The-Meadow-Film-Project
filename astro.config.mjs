import { defineConfig } from 'astro/config';

export default defineConfig({
  output: 'static',
  server: { port: parseInt(process.env.PORT) || 4322 },
});
