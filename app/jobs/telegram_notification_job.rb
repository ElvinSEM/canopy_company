# app/jobs/telegram_notification_job.rb
class TelegramNotificationJob < ApplicationJob
  queue_as :default

  def perform(lead_id)
    lead = Lead.find_by(id: lead_id)
    return unless lead # Если Лид вдруг удалили, выходим

    TelegramNotifier.new.send_new_lead_notification(lead)
  end
end