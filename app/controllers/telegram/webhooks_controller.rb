# app/controllers/telegram/webhooks_controller.rb
module Telegram
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token # Важно для внешних запросов

    def callback
      # Telegram отправляет обновление в параметре `update`
      update = params[:update]

      if update && update['message'] && update['message']['text']
        message_text = update['message']['text']
        chat_id = update['message']['chat']['id']

        # Обрабатываем команду /start с параметром
        if message_text.start_with?('/start invite_')
          handle_invite_start(message_text, chat_id)
        end
      end

      head :ok # Всегда отвечаем 200 OK Telegram
    end

    private

    def handle_invite_start(message_text, chat_id)
      # Извлекаем ID лида и токен из команды /start invite_123_abc
      parts = message_text.split('_')
      lead_id = parts[1].to_i
      token = parts[2]

      lead = Lead.find_by(id: lead_id, invite_token: token)

      if lead
        # 1. Сохраняем chat_id лида для будущей связи
        lead.update(telegram_chat_id: chat_id)

        # 2. Отправляем приветствие и кнопку-ссылку на канал
        bot.send_message(
          chat_id: chat_id,
          text: "Привет, #{lead.name}! Спасибо за интерес. Подпишись на наш канал с работами, а затем нажми кнопку ниже.",
          reply_markup: {
            inline_keyboard: [[
                                {
                                  text: "✅ Я подписался на канал",
                                  callback_data: "check_subscription_#{lead.id}"
                                }]
            ]
          }.to_json
        )
      else
        bot.send_message(
          chat_id: chat_id,
          text: "Ссылка недействительна или устарела."
        )
      end
    end

    def bot
      @bot ||= Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
    end
  end
end