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



# Самый простой Dockerfile - только essentials
FROM ruby:3.4.6-slim

# Абсолютный минимум пакетов
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    libpq-dev postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Устанавливаем только production гемы
COPY Gemfile Gemfile.lock ./
RUN bundle config set without 'development test' && \
    bundle install --jobs=1 --retry=1

# Копируем приложение
COPY . .

EXPOSE 3000