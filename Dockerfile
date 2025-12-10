# FROM node:18-alpine

# WORKDIR /app

# COPY package*.json ./

# RUN npm install --only=production

# COPY . .

# EXPOSE 3000

# CMD ["node", "src/app.js"]

FROM node:18-alpine AS builder

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

COPY . .

FROM node:18-alpine AS runner

USER node

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 3000

CMD ["node", "src/app.js"]
