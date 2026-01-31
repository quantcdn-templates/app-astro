# Production image - expects pre-built artifacts from CI
# The build happens in CI workflow natively, then artifacts are copied here
ARG NODE_VERSION=22
FROM ghcr.io/quantcdn-templates/app-node:${NODE_VERSION}

WORKDIR /app

# Copy custom entrypoint scripts (add your own .sh files in quant/entrypoints/)
COPY quant/entrypoints/ /quant-entrypoint.d/
RUN find /quant-entrypoint.d -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# Copy pre-built application (built in CI workflow, not in Docker)
COPY --chown=node:node dist ./dist
COPY --chown=node:node node_modules ./node_modules
COPY --chown=node:node package*.json ./

ENV HOST=0.0.0.0
ENV PORT=4321

EXPOSE 4321

CMD ["node", "dist/server/entry.mjs"]
