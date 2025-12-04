# spec/rails_helper.rb
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'devise'

# Подключаем все файлы в spec/support
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.before(:each) do
    ActiveJob::Base.queue_adapter = :test
    # очистка очереди между примерами
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    ActiveJob::Base.queue_adapter.performed_jobs.clear
  end

  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system

  # config.infer_spec_type_from_file_location!
  # config.filter_rails_from_backtrace!

  # Подключаем FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Подключаем Devise helpers для разных типов тестов
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system

  # ДОБАВЬТЕ СЮДА - для ActiveAdmin тестов
  config.before(:each, type: :request) do
    admin_user = create(:admin_user)
    sign_in admin_user
  end

  config.before(:each, type: :system) do
    admin_user = create(:admin_user)
    sign_in admin_user
  end
end

# Конфигурация Shoulda Matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end