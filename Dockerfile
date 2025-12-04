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
#COPY package.json yarn.lock ./
#RUN yarn install --frozen-lockfile
#
#COPY Gemfile Gemfile.lock ./
#RUN bundle install
#
#COPY . .
#
#CMD ["bin/rails", "server", "-b", "0.0.0.0"]




FROM ruby:3.4.6-slim AS base

# 1. Установка системных зависимостей
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

# 2. Установка зависимостей Node.js (с кэшированием)
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# 3. Установка Ruby гемов (с кэшированием)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 4. Копирование всего кода
COPY . .

# ⚠️ КРИТИЧЕСКО ВАЖНО: сборка Vite ассетов для production
RUN bin/vite build

# 5. Предкомпиляция Rails ассетов
RUN bundle exec rails assets:precompile

# 6. Порт для Render (должен совпадать с переменной PORT в настройках Render)
EXPOSE 10000

# 7. Команда запуска с портом из переменной окружения PORT
CMD ["sh", "-c", "bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"]