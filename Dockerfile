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

# 1. Копируем и устанавливаем зависимости Node
COPY package.json yarn.lock ./

# Важно: Устанавливаем vite явно, чтобы гарантировать его наличие.
# Это решение проблемы, когда vite есть в package.json, но не устанавливается.
RUN yarn add vite

# Затем устанавливаем все остальные зависимости
RUN yarn install --frozen-lockfile

# 2. Копируем и устанавливаем Ruby гемы
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 3. Копируем весь код приложения
COPY . .

# 4. ПРЕДВАРИТЕЛЬНАЯ ПРОВЕРКА: Убеждаемся, что vite доступен
RUN npx vite --version || echo "Vite check failed"

# 5. Теперь запускаем сборку Vite
RUN bin/vite build

# 6. Предкомпиляция Rails ассетов
RUN bundle exec rails assets:precompile

EXPOSE 10000

CMD ["sh", "-c", "bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"]