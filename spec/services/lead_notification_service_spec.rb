require 'rails_helper'

RSpec.describe LeadNotificationService do
  let(:lead) { create(:lead) }

  describe '.notify_new_lead' do
    it 'sends new lead notification' do
      expect {
        LeadNotificationService.notify_new_lead(lead)
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
             .with('LeadMailer', 'new_lead_notification', 'deliver_later', args: [lead])
    end
  end

  describe '.notify_status_update' do
    it 'sends status update notification' do
      expect {
        LeadNotificationService.notify_status_update(lead)
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
             .with('LeadMailer', 'lead_status_updated', 'deliver_later', args: [lead])
    end
  end
end