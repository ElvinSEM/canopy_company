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

# 1. Копируем конфигурацию Yarn первой
COPY .yarnrc.yml ./

# 2. Копируем и устанавливаем все Node.js зависимости (включая dev)
COPY package.json yarn.lock ./
RUN yarn install --immutable

# 3. Копируем и устанавливаем Ruby гемы
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 4. Копируем весь код приложения
COPY . .

# 5. Сборка Vite (теперь пакеты доступны)
RUN bin/vite build

# 6. Предкомпиляция Rails ассетов
#RUN bundle exec rails assets:precompile

EXPOSE 10000

CMD ["sh", "-c", "bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"]