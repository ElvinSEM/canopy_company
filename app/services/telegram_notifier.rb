# app/services/telegram_notifier.rb
require 'telegram/bot'
require 'net/http'
require 'json'
class TelegramNotifier
  def initialize
    @token = ENV['TELEGRAM_BOT_TOKEN']
    @chat_id = ENV['TELEGRAM_CHAT_ID']
  end

  # Главный метод, который будет вызываться
  def send_new_lead_notification(lead)
    message = format_lead_message(lead)
    send_message(message)
  end

  def send_message(text, parse_mode: nil)
    # По умолчанию: админские уведомления - с Markdown, пользовательские - без
    default_parse_mode = @chat_id == ENV['TELEGRAM_CHAT_ID'] ? 'Markdown' : nil

    json_data = {
      chat_id: @chat_id,
      text: text,
      parse_mode: parse_mode || default_parse_mode
    }.compact # Удаляем nil значения

    json_data_escaped = json_data.to_json.gsub("'", "'\"'\"'")

    command = "curl -s -X POST 'https://api.telegram.org/bot#{@token}/sendMessage' " \
      "-H 'Content-Type: application/json' " \
      "-d '#{json_data_escaped}'"

    Rails.logger.debug "TelegramNotifier: #{json_data[:parse_mode] || 'no parse mode'}"

    result = `#{command}`

    begin
      json_result = JSON.parse(result)
      if json_result['ok']
        Rails.logger.info "Telegram message sent (message_id: #{json_result.dig('result', 'message_id')})"
        json_result
      else
        Rails.logger.error "Telegram API error: #{json_result['description']}"
        # Если ошибка Markdown, пробуем без него
        if json_result['description']&.include?('parse entities') && json_data[:parse_mode]
          Rails.logger.info "Retrying without Markdown..."
          send_message(text, parse_mode: nil)
        else
          nil
        end
      end
    rescue JSON::ParserError
      Rails.logger.error "Failed to parse Telegram response: #{result}"
      nil
    end
  end


  private

  def format_lead_message(lead)
    # Генерируем ссылку ТОЛЬКО если лид сохранен в БД (у него есть id)
    admin_link = if lead.persisted? && lead.id.present?
                   # Используйте ваш реальный домен вместо 'ваш-домен.ru'
                   Rails.application.routes.url_helpers.admin_lead_url(lead, host: 'localhost', port: 3000)
                 else
                   'Лид еще не сохранен в базе'
                 end

    <<~MESSAGE
  🎯 *Новый лид с сайта!*

  👤 *Имя:* #{lead.name}
  📞 *Телефон:* `#{lead.phone || 'не указан'}`
  📧 *Email:* #{lead.email || 'не указан'}
  📝 *Сообщение:* #{lead.message.present? ? "\n#{lead.message.truncate(300)}" : 'нет'}

  🕐 *Время:* #{I18n.l(lead.created_at || Time.current, format: :long)}
  🔗 *Админка:* #{admin_link}
  MESSAGE
  end

end