# app/services/lead_notification_service.rb
class LeadNotificationService
  def self.notify_new_lead(lead)
    # ЗАМЕНИТЕ эту строку:
    # LeadMailer.new_lead_notification(lead).deliver_later
    # НА ЭТУ:
    LeadMailer.with(lead: lead).new_lead_notification.deliver_later
  end

  def self.notify_status_updated(lead)
    # ЗАМЕНИТЕ эту строку:
    # LeadMailer.lead_status_updated(lead).deliver_later
    # НА ЭТУ:
    LeadMailer.with(lead: lead).lead_status_updated.deliver_later
  end
end