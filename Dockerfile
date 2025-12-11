# Build stage
ARG NODE_VERSION=22
FROM node:${NODE_VERSION}-bookworm-slim AS builder

WORKDIR /build

# Copy package files first for better caching
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# Production stage - use Quant's Node base image
FROM ghcr.io/quantcdn-templates/app-node:${NODE_VERSION}

WORKDIR /app

# Copy custom entrypoint scripts (add your own .sh files in quant/entrypoints/)
COPY quant/entrypoints/ /quant-entrypoint.d/
RUN find /quant-entrypoint.d -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# Copy built application from builder
COPY --from=builder --chown=node:node /build/dist ./dist
COPY --from=builder --chown=node:node /build/package*.json ./

# Install production dependencies only
RUN npm ci --omit=dev

ENV HOST=0.0.0.0
ENV PORT=4321

EXPOSE 4321

CMD ["node", "dist/server/entry.mjs"]
