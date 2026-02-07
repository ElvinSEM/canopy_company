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
FROM ruby:3.4.8-alpine3.23

RUN apk --update add --no-cache \
    build-base \
    yaml-dev \
    tzdata \
    nodejs \
    npm \
    libc6-compat \
    postgresql-dev \
    curl \
    ruby-dev \
    vips-dev \
    && rm -rf /var/cache/apk/*

# Устанавливаем Corepack через npm, а затем включаем его
RUN npm i -g corepack && \
    corepack enable

# Подготавливаем Yarn 4.6.0 через Corepack
RUN corepack prepare yarn@4.6.0 --activate
RUN yarn set version 4.6.0

ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v $(tail -n 1 Gemfile.lock)
RUN bundle check || bundle install --jobs=2 --retry=3
RUN bundle clean --force

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

RUN addgroup -g 1000 deploy && adduser -u 1000 -G deploy -D -s /bin/sh deploy
USER deploy:deploy

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]