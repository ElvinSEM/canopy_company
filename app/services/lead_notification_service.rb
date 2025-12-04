# app/services/lead_notification_service.rb
class LeadNotificationService
  def self.notify_new_lead(lead)
    LeadMailer.new_lead_notification(lead).deliver_later
  end

  def self.notify_status_update(lead)
    LeadMailer.lead_status_updated(lead).deliver_later
  end
end
