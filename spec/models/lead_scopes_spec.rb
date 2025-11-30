# spec/models/lead_scopes_spec.rb
require 'rails_helper'

RSpec.describe 'Lead Scopes', type: :model do
  describe '.new_leads' do
    it 'returns only leads with status Новая' do
      new_lead = create(:lead, status: 'Новая')
      in_progress_lead = create(:lead, status: 'В работе')

      expect(Lead.new_leads).to include(new_lead)
      expect(Lead.new_leads).not_to include(in_progress_lead)
    end
  end

  describe '.recent' do
    it 'returns limited number of leads' do
      create_list(:lead, 10)
      expect(Lead.recent(5).count).to eq(5)
    end
  end
end