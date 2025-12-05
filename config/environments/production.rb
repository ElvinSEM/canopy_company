require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.hosts = [
    "canopy-company.onrender.com"
  ]
  config.hosts << /.*\.onrender\.com/

  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.assets.compile = false
  config.active_storage.service = :local
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present? || ENV['RENDER'].present?
  config.force_ssl = true

  config.logger =
    ActiveSupport::Logger.new(STDOUT)
                         .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
                         .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [:request_id]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false

  # ============================================================
  # 🔥 HOST AUTHORIZATION (РАБОТАЕТ НА RENDER БЕЗ ОШИБОК)
  # ============================================================

  config.hosts.clear   # сначала очищаем дефолтные значения

  # 1) Явно разрешаем свой Render-хост (ВАЖНО!)
  config.hosts << "canopy-company.onrender.com"

  # 2) Разрешаем любые поддомены *.onrender.com (для превью и билдов)
  config.hosts << /.*\.onrender\.com/

  # 3) Если есть переменная среды RAILS_HOSTS — разбираем и добавляем
  if ENV["RAILS_HOSTS"].present?
    ENV["RAILS_HOSTS"].split(',').each do |host|
      config.hosts << host.strip
    end
  end

  # 4) health check /up не проходит через HostAuthorization
  config.host_authorization = {
    exclude: ->(request) { request.path == "/up" }
  }

  # Rails.logger.info "👉 Allowed hosts: #{config.hosts.inspect}"
end
