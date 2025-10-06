FROM node:22 AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .
# RUN npm run build

FROM gcr.io/distroless/nodejs22-debian12
WORKDIR /app

COPY --from=builder /app .
# COPY --from=builder /app/dist ./dist
# COPY --from=builder /app/node_modules ./node_modules
# COPY package*.json ./

EXPOSE 3000

CMD ["app.ts"]