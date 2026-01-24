# app/jobs/telegram_polling_job.rb
class TelegramPollingJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 5, dead: false

  def perform(offset = TelegramOffsetStore.get)
    token = ENV['TELEGRAM_BOT_TOKEN']

    # 1. Получаем обновления от Telegram
    updates = get_updates(token, offset)

    # 2. Обрабатываем каждое обновление
    new_offset = offset
    updates.each do |update|
      new_offset = update['update_id'] + 1
      process_update(update)
    end

    # 3. Сохраняем позицию и ставим следующий запуск
    TelegramOffsetStore.set(new_offset) if new_offset > offset
    TelegramPollingJob.perform_in(1.second, new_offset) unless Rails.env.test?

  rescue => e
    Rails.logger.error "TelegramPollingJob error: #{e.message}"
    TelegramPollingJob.perform_in(10.seconds, offset) # Перезапуск через 10 сек
  end

  private

  def get_updates(token, offset)
    uri = URI("https://api.telegram.org/bot#{token}/getUpdates")
    params = { offset: offset, timeout: 25, limit: 100 }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get(uri)
    JSON.parse(response)['result'] || []
  end

  def process_update(update)
    return unless update['message']

    message = update['message']
    chat_id = message['chat']['id']
    text = message['text'].to_s

    if text.start_with?('/start')
      handle_start_command(message)
    elsif text.include?('✅ Я подписался') || text.downcase.include?('подписал')
      handle_subscription_confirmation(message)
    end
  end

  def handle_start_command(message)
    chat_id = message['chat']['id']
    text = message['text']

    # Извлекаем токен из /start invite_123_abc
    if text.include?('invite_')
      token_parts = text.split('invite_').last.split('_')
      lead_id = token_parts[0].to_i
      invite_token = token_parts[1]

      # Находим лида
      lead = Lead.find_by(id: lead_id, invite_token: invite_token)

      if lead
        # Сохраняем chat_id для будущей связи
        lead.update(telegram_chat_id: chat_id)

        # Отправляем приветствие и кнопку
        send_telegram_message(
          chat_id: chat_id,
          text: "👋 Привет, #{lead.name}! Спасибо за интерес!\n\nПодпишитесь на наш канал @naves_crimea, а затем нажмите кнопку ниже:",
          reply_markup: {
            keyboard: [[{ text: "✅ Я подписался на канал" }]],
            resize_keyboard: true,
            one_time_keyboard: true
          }.to_json
        )

        # Уведомляем админа
        notify_admin("🆕 Клиент перешёл по ссылке: #{lead.name} (#{lead.phone})")
      else
        send_telegram_message(
          chat_id: chat_id,
          text: "❌ Ссылка недействительна. Пожалуйста, оставьте заявку на сайте."
        )
      end
    else
      send_telegram_message(
        chat_id: chat_id,
        text: "👋 Для начала работы перейдите по ссылке, полученной после заполнения заявки."
      )
    end
  end

  def handle_subscription_confirmation(message)
    chat_id = message['chat']['id']

    # Ищем лида по telegram_chat_id
    lead = Lead.find_by(telegram_chat_id: chat_id)

    if lead
      # Проверяем подписку на канал (бот должен быть администратором канала)
      if user_subscribed_to_channel?(chat_id)
        lead.update(subscribed_to_channel: true, subscription_confirmed_at: Time.current)

        # Поздравляем клиента
        send_telegram_message(
          chat_id: chat_id,
          text: "🎉 Отлично! Спасибо за подписку, #{lead.name}!\n\nТеперь вы будете первыми видеть наши новые работы. Скоро с вами свяжется менеджер."
        )

        # Уведомляем админа
        notify_admin("✅ Клиент подписался на канал: #{lead.name} (#{lead.phone})")
      else
        send_telegram_message(
          chat_id: chat_id,
          text: "❌ Кажется, вы ещё не подписались на наш канал @naves_crimea.\n\nПодпишитесь и нажмите кнопку снова."
        )
      end
    end
  end

  def user_subscribed_to_channel?(user_id)
    # Для проверки ваш бот должен быть администратором канала @naves_crimea
    channel_id = ENV['TELEGRAM_CHANNEL_ID'] # ID канала в формате -1001234567890
    return false unless channel_id

    token = ENV['TELEGRAM_BOT_TOKEN']
    uri = URI("https://api.telegram.org/bot#{token}/getChatMember")

    params = { chat_id: channel_id, user_id: user_id }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get(uri)
    result = JSON.parse(response)

    status = result.dig('result', 'status')
    ['creator', 'administrator', 'member'].include?(status)
  rescue => e
    Rails.logger.error "Subscription check error: #{e.message}"
    false
  end

  def send_telegram_message(params)
    token = ENV['TELEGRAM_BOT_TOKEN']
    uri = URI("https://api.telegram.org/bot#{token}/sendMessage")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = params.to_json

    http.request(request)
  end

  def notify_admin(text)
    # Используем существующий TelegramNotifier
    TelegramNotifier.new.send_message(text) rescue nil
  end
end