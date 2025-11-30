# spec/services/lead_statistics_spec.rb
require 'rails_helper'

RSpec.describe LeadStatistics do
  before do
    # Очищаем и создаем тестовые данные
    Lead.destroy_all
  end

  describe '.status_counts' do
    it 'returns correct status counts' do
      create_list(:lead, 2, status: 'Новая')
      create_list(:lead, 3, status: 'В работе')
      create(:lead, status: 'Завершена')

      counts = LeadStatistics.status_counts

      expect(counts['Новая']).to eq(2)
      expect(counts['В работе']).to eq(3)
      expect(counts['Завершена']).to eq(1)
    end

    it 'returns empty hash when no leads' do
      expect(LeadStatistics.status_counts).to eq({})
    end
  end

  describe '.recent_leads' do
    it 'returns limited number of leads' do
      create_list(:lead, 10)
      recent = LeadStatistics.recent_leads(5)
      expect(recent.count).to eq(5)
    end

    it 'returns leads ordered by creation date' do
      old_lead = create(:lead, created_at: 2.days.ago)
      new_lead = create(:lead, created_at: 1.day.ago)

      recent = LeadStatistics.recent_leads(2)
      expect(recent.first).to eq(new_lead)
      expect(recent.last).to eq(old_lead)
    end
  end

  describe '.leads_today' do
    it 'returns count of leads created today' do
      create(:lead, created_at: Time.current)
      create(:lead, created_at: 1.day.ago) # Вчера

      expect(LeadStatistics.leads_today).to eq(1)
    end
  end
end