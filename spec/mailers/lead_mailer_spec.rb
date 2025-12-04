require 'rails_helper'

RSpec.describe LeadMailer, type: :mailer do
  let(:lead) { build(:lead, name: 'Иван Иванов', email: 'test@example.com', status: 'Новая') }

  describe '#new_lead_notification' do
    let(:mail) { LeadMailer.new_lead_notification(lead) }

    it 'sends to admin email' do
      expect(mail.to).to eq(['admin@example.com'])
    end

    it 'has correct subject' do
      expect(mail.subject).to eq('Новая заявка с сайта')
    end

    it 'includes lead information' do
      expect(mail.body.encoded).to include('Иван Иванов')
      expect(mail.body.encoded).to include('test@example.com')
    end
  end

  describe '#lead_status_updated' do
    let(:mail) { LeadMailer.lead_status_updated(lead) }

    it 'sends to lead email' do
      expect(mail.to).to eq(['test@example.com'])
    end

    it 'has correct subject' do
      expect(mail.subject).to eq('Статус вашей заявки обновлен')
    end

    it 'includes lead name' do
      expect(mail.body.encoded).to include('Иван Иванов')
    end

    it 'includes status information' do
      expect(mail.body.encoded).to include('Новая')
    end
  end
end