# Stage 1: Build
FROM oven/bun:canary-alpine AS builder
WORKDIR /app
COPY package.json bun.lock ./
RUN bun install
COPY . .
RUN bun run build

# Stage 2: Deploy (stripped image)
FROM oven/bun:canary-alpine

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

RUN adduser -D bunuser

USER bunuser
EXPOSE 3333
CMD ["bun", "dist/infra/http/server.js"]