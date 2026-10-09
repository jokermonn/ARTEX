# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim AS frontend
WORKDIR /src/web
COPY web/package.json web/package-lock.json ./
RUN npm ci
COPY web/ ./
ENV NEXT_TELEMETRY_DISABLED=1
RUN npm run build:static

FROM golang:1.26.3-bookworm AS backend
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . ./
COPY --from=frontend /src/web/out/ /src/server/webui/dist/
RUN CGO_ENABLED=0 go build -tags embedui -o /build/artex ./cmd/artex

FROM node:22-bookworm-slim AS runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip ca-certificates ripgrep curl wget vim git jq unzip \
    dnsutils iputils-ping netcat-openbsd inetutils-telnet whois nmap \
    && rm -rf /var/lib/apt/lists/*
# 和官方运行镜像一样提供浏览器工具；初次构建后需记录实际版本。
RUN npm install -g @playwright/mcp @playwright/cli playwright \
    && playwright-cli --help \
    && playwright install --with-deps chromium \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=backend /build/artex /app/artex
COPY start.sh /app/start.sh
COPY skills/ /app/skills/
RUN chmod +x /app/artex /app/start.sh
EXPOSE 8787
ENTRYPOINT ["/app/start.sh"]
CMD ["-addr", ":8787", "-proxy", "127.0.0.1:8788"]
