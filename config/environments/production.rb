require "active_support/core_ext/integer/time"
Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.assets.compile = false
  config.active_storage.service = :local
  config.force_ssl = true
  config.logger = ActiveSupport::Logger.new(STDOUT)
                                       .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
                                       .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false

  # ===== КЛЮЧЕВОЙ ФРАГМЕНТ: НАСТРОЙКА РАЗРЕШЕННЫХ ХОСТОВ =====
  # Сначала очищаем дефолтные хосты (localhost и т.д.)
  config.hosts.clear

  # Разрешаем хосты из переменной окружения RAILS_HOSTS
  allowed_hosts = ENV['RAILS_HOSTS'].to_s.split(',').map(&:strip)

  if allowed_hosts.any?
    config.hosts = allowed_hosts
  else
    # Если переменная не задана, разрешаем все поддомены Render
    config.hosts << /[a-z0-9-]+\.onrender\.com/
  end

  # Исключаем health check путь /up из проверки хостов
  config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # Логируем, какие хосты настроены (для отладки)
  Rails.logger.info "Allowed hosts configured: #{config.hosts.inspect}"
  # ===== КОНЕЦ КЛЮЧЕВОГО ФРАГМЕНТА =====
end