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
#
#
#


FROM ruby:3.4.6-slim AS build

ENV RAILS_ENV=production \
    NODE_ENV=production \
    BUNDLE_WITHOUT="development test"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libpq-dev \
    curl \
    nodejs \
    npm \
    libvips \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Yarn
RUN corepack enable && corepack prepare yarn@4.6.0 --activate

# Node deps
COPY package.json yarn.lock ./
RUN yarn install --immutable

# Ruby deps
COPY Gemfile Gemfile.lock ./
RUN bundle config set force_ruby_platform true && \
    bundle install --jobs=4 --retry=3

# App code
COPY . .

# Assets
RUN bundle exec rails assets:precompile && \
    bundle exec rails vite:build

############################
# 2. RUNTIME STAGE
############################
FROM ruby:3.4.6-slim

ENV RAILS_ENV=production \
    NODE_ENV=production \
    BUNDLE_WITHOUT="development test"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    libpq5 \
    libvips \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Ruby gems
COPY --from=build /usr/local/bundle /usr/local/bundle

# App
COPY --from=build /app /app

# Entrypoint
COPY entrypoint.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/entrypoint

EXPOSE 3000

ENTRYPOINT ["entrypoint"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
