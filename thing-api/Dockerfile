FROM chainguard/node:latest-dev AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

FROM chainguard/node:latest
WORKDIR /app
COPY --from=builder /app .

EXPOSE 3000

CMD ["app.ts"]