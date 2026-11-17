# -------------------------------------------------------------
# Stage 1: Build & Dependencies
# -------------------------------------------------------------
FROM node:20-alpine AS dependencies
WORKDIR /app

# Install build dependencies if needed
COPY package*.json ./
RUN npm ci --omit=dev

# -------------------------------------------------------------
# Stage 2: Final Production Runtime
# -------------------------------------------------------------
FROM node:20-alpine AS runner
WORKDIR /app

# Install curl for healthcheck and python3 for analysis script
RUN apk add --no-cache curl python3

# Set environment
ENV NODE_ENV=production
ENV PORT=5000

# Copy production node_modules from builder
COPY --from=dependencies /app/node_modules ./node_modules
COPY package*.json ./
COPY . .

# Create uploads directory and set permissions for non-root user 'node'
RUN mkdir -p /app/uploads/audio /app/uploads/midi /app/uploads/sheets /app/uploads/reference-audio && \
    chown -R node:node /app

# Switch to non-root user (security best practice)
USER node

EXPOSE 5000

HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

CMD ["node", "app.js"]
