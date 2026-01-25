#
#FROM ruby:3.4.6-slim
#
## Установка системных зависимостей
#RUN apt-get update -qq && apt-get install -y --no-install-recommends \
#    curl gnupg build-essential git libpq-dev nodejs npm \
#    libvips libyaml-dev postgresql-client \
#    && rm -rf /var/lib/apt/lists/*
#
## Включаем Corepack для управления версиями Yarn
#RUN corepack enable
#
#WORKDIR /app
#
## Копируем конфигурационные файлы пакетов
#COPY package.json yarn.lock ./
#
## Подготавливаем Yarn 4.6.0 через Corepack
#RUN corepack prepare yarn@4.6.0 --activate && \
#    yarn set version 4.6.0 && \
#    yarn --version
#
## Устанавливаем Node.js зависимости
#RUN yarn install --immutable
#
## Устанавливаем Ruby гемы
#COPY Gemfile Gemfile.lock ./
#RUN bundle config set force_ruby_platform true && \
#    bundle install --jobs=4 --retry=3
#
## Копирование остального кода
#COPY . .
#
## Создание необходимых директорий
#RUN mkdir -p tmp/pids tmp/cache tmp/sockets public/vite-dev
#
## Entrypoint
#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#ENTRYPOINT ["/usr/bin/entrypoint.sh"]
#
#EXPOSE 3000
#
#CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


FROM ruby:3.4.6-slim AS builder

# Установка системных зависимостей (только runtime + build essentials для сборки)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg build-essential git \
    libpq-dev libvips libyaml-dev \
    postgresql-client pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Установка Node.js 20 (более стабильная версия)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    corepack enable

WORKDIR /app

# 1. Устанавливаем Node.js зависимости с кэшированием
COPY package.json yarn.lock ./
RUN --mount=type=cache,target=/root/.npm \
    --mount=type=cache,target=/usr/local/share/.cache/yarn \
    corepack prepare yarn@4.6.0 --activate && \
    yarn set version 4.6.0 && \
    yarn install --immutable --frozen-lockfile && \
    yarn cache clean

# 2. Устанавливаем Ruby гемы с кэшированием
COPY Gemfile Gemfile.lock ./
RUN --mount=type=cache,target=/usr/local/bundle/cache \
    bundle config set force_ruby_platform true && \
    bundle config set deployment 'true' && \
    bundle config set without 'development test' && \
    bundle config set jobs 4 && \
    bundle install --retry=3 && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems -name "*.c" -delete && \
    find /usr/local/bundle/gems -name "*.o" -delete

# 3. Копируем остальной код
COPY . .

# 4. Precompile assets (в production)
RUN RAILS_ENV=production NODE_ENV=production \
    bundle exec rails assets:precompile && \
    bundle exec rails vite:build

# 5. Удаляем ненужные файлы для уменьшения размера образа
RUN rm -rf node_modules spec test tmp/cache .git .github \
    && find /usr/local/bundle/gems -name "*.md" -delete \
    && find /usr/local/bundle/gems -name "*.txt" -delete \
    && find /usr/local/bundle/gems -name "*.rdoc" -delete

# ==================== FINAL IMAGE ====================
FROM ruby:3.4.6-slim

# Только runtime зависимости (без build-essential)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    curl libpq-dev libvips libyaml-dev \
    postgresql-client tzdata \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Создаем пользователя для безопасности
RUN groupadd -r rails && useradd -r -g rails rails \
    && mkdir -p tmp/pids tmp/cache tmp/sockets log \
    && chown -R rails:rails /app

# Копируем установленные гемы из builder stage
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder --chown=rails:rails /app /app

# Переключаемся на непривилегированного пользователя
USER rails

# Entrypoint
COPY --chown=rails:rails entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]