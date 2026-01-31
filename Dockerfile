# syntax=docker/dockerfile:1
# Build stage - runs on native platform to avoid QEMU emulation issues
ARG NODE_VERSION=22
FROM --platform=$BUILDPLATFORM node:${NODE_VERSION}-bookworm-slim AS builder

WORKDIR /build

# Copy package files and install all dependencies
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# Install production dependencies only
RUN rm -rf node_modules && npm ci --omit=dev

# Production stage - multi-arch compatible
FROM ghcr.io/quantcdn-templates/app-node:${NODE_VERSION}

WORKDIR /app

# Copy custom entrypoint scripts
COPY quant/entrypoints/ /quant-entrypoint.d/
RUN find /quant-entrypoint.d -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# Copy built application from builder
COPY --from=builder --chown=node:node /build/dist ./dist
COPY --from=builder --chown=node:node /build/node_modules ./node_modules
COPY --from=builder --chown=node:node /build/package*.json ./

ENV HOST=0.0.0.0
ENV PORT=4321

EXPOSE 4321

CMD ["node", "dist/server/entry.mjs"]
