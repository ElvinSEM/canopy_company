# config/initializers/telegram_bot.rb
if Rails.application.config.active_job.queue_adapter == :sidekiq
  Rails.application.config.after_initialize do
    unless Rails.env.test? || File.basename($0) == 'rake'
      # Ждём 5 секунд после старта и запускаем
      Thread.new do
        sleep 5
        TelegramPollingJob.perform_async(TelegramOffsetStore.get)
        Rails.logger.info "Telegram polling job enqueued"
      end
    end
  end
end