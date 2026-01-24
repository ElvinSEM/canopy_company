# config/initializers/ssl_fix.rb
# ФИНАЛЬНОЕ ИСПРАВЛЕНИЕ для OpenSSL 3.6 и Ruby 3.4
require 'openssl'
require 'net/http'

# 1. ПАТЧ ДЛЯ ВСЕХ НОВЫХ SSL-СОЕДИНЕНИЙ
class OpenSSL::SSL::SSLContext
  # Переопределяем инициализатор SSLContext
  alias original_initialize initialize

  def initialize(*args)
    original_initialize(*args)

    # ОТКЛЮЧАЕМ ПРОВЕРКУ CRL (причина ошибки)
    # Пробуем оба способа:

    # Способ A: через verify_flags (если метод есть)
    if respond_to?(:verify_flags=)
      self.verify_flags = OpenSSL::X509::V_FLAG_TRUSTED_FIRST
    end

    # Способ B: через cert_store (работает всегда)
    store = self.cert_store || OpenSSL::X509::Store.new
    store.flags = OpenSSL::X509::V_FLAG_TRUSTED_FIRST
    self.cert_store = store

    # Способ C: если ничего не помогает, ОТКЛЮЧАЕМ ПРОВЕРКУ СЕРТИФИКАТОВ (ВРЕМЕННО!)
    # Раскомментируйте следующую строку только для теста:
    # self.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
end

# 2. ДОПОЛНИТЕЛЬНЫЙ ПАТЧ ДЛЯ Net::HTTP
module Net
  class HTTP
    # Гарантируем, что при установке use_ssl используется наш исправленный контекст
    alias original_use_ssl= use_ssl=

    def use_ssl=(flag)
      original_use_ssl=(flag)
      return unless flag

      # Создаём SSL контекст с нашими настройками
      @ssl_context = OpenSSL::SSL::SSLContext.new
    end
  end
end

Rails.logger.info '[SSL Fix] Глобально отключена проверка CRL для всех SSL соединений'