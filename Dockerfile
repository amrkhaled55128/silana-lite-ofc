# syntax=docker/dockerfile:1
FROM node:20-bookworm-slim

# Install system deps (ffmpeg and build tools for native modules)
RUN apt-get update && apt-get install -y \
    ffmpeg \
    wget \
    python3 \
    make \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install JS deps first (respect lockfile if present)
COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci --legacy-peer-deps; else npm install --legacy-peer-deps; fi

# Copy source
COPY . .

ENV NODE_ENV=production

CMD ["npm", "start"]
