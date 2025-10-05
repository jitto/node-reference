FROM chainguard/node:latest-dev AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM chainguard/node:latest

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./

ENV HOST=0.0.0.0
ENV PORT=4321

EXPOSE 4321

CMD ["./dist/server/entry.mjs"]