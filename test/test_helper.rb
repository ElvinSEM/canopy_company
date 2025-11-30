# test/test_helper.rb
require 'simplecov'

# Запускаем SimpleCov только когда явно указано
if ENV['COVERAGE']
  SimpleCov.start 'rails' do
    puts "🔍 Starting SimpleCov for test coverage"

    # Группируем файлы
    add_group 'Models', 'app/models'
    add_group 'Controllers', 'app/controllers'
    add_group 'Admin', 'app/admin'

    # Минимальное покрытие
    minimum_coverage 80

    # Игнорируем
    add_filter '/bin/'
    add_filter '/db/'
    add_filter '/test/'
    add_filter '/config/'
  end
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end