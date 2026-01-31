# Build stage - runs natively (not emulated) for faster builds
# The built JavaScript is architecture-independent
ARG NODE_VERSION=22
ARG BUILDPLATFORM=linux/amd64
FROM --platform=$BUILDPLATFORM node:${NODE_VERSION}-bookworm-slim AS builder

WORKDIR /build

# Copy package files and install all dependencies
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# Clean up and reinstall production-only dependencies
# This creates a clean node_modules with only what's needed at runtime
RUN rm -rf node_modules && npm ci --omit=dev

# Production stage - use Quant's Node base image (multi-arch compatible)
FROM ghcr.io/quantcdn-templates/app-node:${NODE_VERSION}

WORKDIR /app

# Copy custom entrypoint scripts (add your own .sh files in quant/entrypoints/)
COPY quant/entrypoints/ /quant-entrypoint.d/
RUN find /quant-entrypoint.d -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# Copy built application and production dependencies from builder
# JavaScript and node_modules are architecture-independent for these packages
COPY --from=builder --chown=node:node /build/dist ./dist
COPY --from=builder --chown=node:node /build/node_modules ./node_modules
COPY --from=builder --chown=node:node /build/package*.json ./

ENV HOST=0.0.0.0
ENV PORT=4321

EXPOSE 4321

CMD ["node", "dist/server/entry.mjs"]
