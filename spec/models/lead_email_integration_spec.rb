require 'rails_helper'

RSpec.describe Lead, type: :model do
  describe 'email notifications' do
    it 'sends new lead notification after create' do
      expect {
        create(:lead)
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
             .with('LeadMailer', 'new_lead_notification', 'deliver_later', any_args)
    end

    it 'sends status update notification when status changes' do
      lead = create(:lead, status: 'Новая')

      expect {
        lead.update!(status: 'В работе')
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
             .with('LeadMailer', 'lead_status_updated', 'deliver_later', any_args)
    end

    it 'does not send notification when other fields change' do
      lead = create(:lead)

      expect {
        lead.update!(name: 'Новое имя')
      }.not_to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end
  end
end