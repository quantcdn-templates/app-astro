# Astro SSR Template for Quant Cloud

[![Deploy to Quant Cloud](https://www.quantcdn.io/img/quant-deploy-btn-sml.svg)](https://dashboard.quantcdn.io/deploy/app/app-astro)

A production-ready Astro template with server-side rendering (SSR) and API routes, built on the Quant Node.js base image.

## Features

- **Server-Side Rendering**: Full SSR using `@astrojs/node` adapter
- **API Routes**: RESTful API endpoint examples
- **Platform Integration**: Inherits SMTP and platform features from `app-node`
- **TypeScript**: Full TypeScript support out of the box

## Quick Start

```bash
# Install dependencies
npm install

# Development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## Docker

```bash
# Build and run with Docker Compose
docker-compose up --build

# Or build manually
docker build -t my-astro-app .
docker run -p 4321:4321 my-astro-app
```

## Project Structure

```
├── src/
│   ├── pages/
│   │   ├── index.astro      # Home page (SSR)
│   │   └── api/
│   │       └── hello.ts     # API endpoint example
│   └── components/          # Astro components
├── astro.config.mjs         # Astro configuration
├── package.json
├── Dockerfile
└── docker-compose.yml
```

## API Routes

The template includes an example API route at `/api/hello`:

```bash
# GET request
curl http://localhost:4321/api/hello

# POST request
curl -X POST http://localhost:4321/api/hello \
  -H "Content-Type: application/json" \
  -d '{"name": "World"}'
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `HOST` | Server bind address | `0.0.0.0` |
| `PORT` | Server port | `4321` |
| `NODE_ENV` | Node environment | `production` |

## Customization

### Adding Pages

Create new `.astro` files in `src/pages/`:

```astro
---
// src/pages/about.astro
const data = await fetch('https://api.example.com/data').then(r => r.json());
---
<html>
  <body>
    <h1>About</h1>
    <p>Data: {JSON.stringify(data)}</p>
  </body>
</html>
```

### Adding API Routes

Create TypeScript files in `src/pages/api/`:

```typescript
// src/pages/api/users.ts
import type { APIRoute } from 'astro';

export const GET: APIRoute = async () => {
  const users = await db.getUsers();
  return new Response(JSON.stringify(users), {
    headers: { 'Content-Type': 'application/json' }
  });
};
```

## License

MIT
