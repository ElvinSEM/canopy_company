set -o errexit

bundle install
yarn install
bundle exec reke assets:precompile
bundle exec reke assets:clean
bundle exec reke db:migratec

