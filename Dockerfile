FROM node:22.18.0-alpine AS base
WORKDIR /usr/src/wpp-server
ENV NODE_ENV=production PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY package.json ./
RUN apk update && \
    apk add --no-cache \
    vips-dev \
    fftw-dev \
    gcc \
    g++ \
    make \
    libc6-compat \
    && rm -rf /var/cache/apk/*
RUN yarn install --production --pure-lockfile && \
    yarn add sharp --ignore-engines && \
    yarn cache clean

FROM base AS build
WORKDIR /usr/src/wpp-server
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY package.json ./
RUN yarn install --production=false --pure-lockfile
RUN yarn cache clean
COPY . .
RUN yarn build

FROM base
WORKDIR /usr/src/wpp-server/

# Instalar Chromium e dependências necessárias
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    && rm -rf /var/cache/apk/*

# Criar usuário não-root para executar Chromium
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Configurar variáveis de ambiente para Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/bin/chromium-browser

RUN yarn cache clean
COPY . .
COPY --from=build /usr/src/wpp-server/ /usr/src/wpp-server/

# Criar diretório para dados do usuário e definir permissões
RUN mkdir -p /usr/src/wpp-server/userDataDir && \
    chown -R nextjs:nodejs /usr/src/wpp-server

# Criar volume para persistência
VOLUME ["/usr/src/wpp-server/userDataDir"]

# Mudar para usuário não-root
USER nextjs

EXPOSE 21465

# Script de inicialização que limpa apenas os locks (preserva dados)
ENTRYPOINT ["sh", "-c", "find /usr/src/wpp-server/userDataDir -name 'SingletonLock' -type f -delete 2>/dev/null || true; find /usr/src/wpp-server/userDataDir -name '.com.google.Chrome.*' -type f -delete 2>/dev/null || true; node dist/server.js"]
