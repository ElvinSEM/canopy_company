source "https://rubygems.org"

ruby "3.4.6"
gem 'rails', '~> 8.1', '>= 8.1.1'
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem 'activeadmin'
gem 'devise', '~> 4.9.0'
gem "image_processing", "~> 1.2"
# Gemfile

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem 'dotenv-rails'
gem "sprockets-rails"
gem 'telegram-bot-ruby', '~> 2.5'
gem 'vite_rails'
gem 'redis', '~> 5.4', '>= 5.4.1'
gem 'sidekiq', '~> 8.1'


group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem 'shoulda-matchers'

end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'letter_opener'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem 'database_cleaner-active_record'
  gem 'simplecov', require: false
  end

gem "rails-controller-testing", "~> 1.0", :group => :test

