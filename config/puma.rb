# Разрешаем безопасный форк для Objective-C объектов (macOS)
ENV["OBJC_DISABLE_INITIALIZE_FORK_SAFETY"] = "YES"

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

rails_env = ENV.fetch("RAILS_ENV") { "development" }

# В production используем несколько воркеров
if rails_env == "production"
  workers Integer(ENV.fetch("WEB_CONCURRENCY") { 2 })
  preload_app!
end

# Таймаут воркеров для разработки
worker_timeout 3600 if rails_env == "development"

# Порт
port ENV.fetch("PORT") { 3000 }

# Окружение
environment rails_env

# PID файл
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Позволяет bin/rails restart
plugin :tmp_restart