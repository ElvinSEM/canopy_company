##
##FROM ruby:3.4.6-slim AS base
##
##RUN apt-get update -qq && apt-get install -y --no-install-recommends \
##    curl \
##    gnupg \
##    build-essential \
##    git \
##    libpq-dev \
##    nodejs \
##    npm \
##    vim \
##    libyaml-dev \
##    && rm -rf /var/lib/apt/lists/*
##
##RUN corepack enable && corepack prepare yarn@4.6.0 --activate
##
##WORKDIR /app
##
##COPY package.json yarn.lock ./
##RUN yarn install --frozen-lockfile
##
##COPY Gemfile Gemfile.lock ./
##RUN bundle install
##
##COPY . .
##
##CMD ["bin/rails", "server", "-b", "0.0.0.0"]
#
#
#FROM ruby:3.4.6-slim AS base
#
#RUN apt-get update -qq && apt-get install -y --no-install-recommends \
#    curl \
#    gnupg \
#    build-essential \
#    git \
#    libpq-dev \
#    nodejs \
#    npm \
#    vim \
#    libyaml-dev \
#    && rm -rf /var/lib/apt/lists/*
#
#RUN corepack enable && corepack prepare yarn@4.6.0 --activate
#
#WORKDIR /app
#
## 1. Конфигурация Yarn для отключения PnP
#RUN echo 'nodeLinker: "node-modules"' > .yarnrc.yml
#
## 2. Установка Node.js зависимостей
#COPY package.json yarn.lock ./
#RUN yarn add @rollup/rollup-linux-arm64-gnu --optional
#
#RUN yarn install --immutable
#
## 3. Установка Ruby гемов
#COPY Gemfile Gemfile.lock ./
#RUN bundle install
#
## 4. Копирование всего кода
#COPY . .
#
## 5. ТОЛЬКО сборка Vite (НЕТ миграций здесь!)
#RUN bin/vite build
#
#EXPOSE 10000
#
## 6. Ключевое изменение: миграции ТОЛЬКО при запуске
#CMD ["sh", "-c", "bundle exec rails db:migrate RAILS_ENV=production && bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"]



FROM ruby:3.4.6-slim AS base

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    build-essential \
    git \
    libpq-dev \
    nodejs \
    npm \
    vim \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

RUN corepack enable && corepack prepare yarn@4.6.0 --activate

WORKDIR /app

# 1. Конфигурация Yarn для отключения PnP
RUN echo 'nodeLinker: "node-modules"' > .yarnrc.yml

# 2. Установка Node.js зависимостей
COPY package.json yarn.lock ./
# Установка проблемного пакета через npm
RUN npm install @rollup/rollup-linux-arm64-gnu --save-optional --no-audit --no-fund
RUN yarn install --immutable

# 3. Установка Ruby гемов
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 4. Копирование всего кода
COPY . .

# 5. Сборка Vite (для production, в development пропускается через флаг)
ARG RAILS_ENV=development
RUN if [ "$RAILS_ENV" = "production" ]; then \
      echo "Building Vite for production..."; \
      bin/vite build; \
    else \
      echo "Skipping Vite build (development mode)"; \
      mkdir -p public/vite && echo '{"dummy":"manifest"}' > public/vite/manifest.json; \
    fi

# 6. Порт
EXPOSE 3000

# 7. Команда запуска
CMD ["sh", "-c", "bundle exec rails db:migrate RAILS_ENV=production && bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"]