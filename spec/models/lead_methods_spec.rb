# spec/models/lead_methods_spec.rb
require 'rails_helper'

RSpec.describe 'Lead Methods', type: :model do
  describe '#status_class' do
    it 'returns correct CSS class for each status' do
      expect(build(:lead, status: 'Новая').status_class).to eq('status-new')
      expect(build(:lead, status: 'В работе').status_class).to eq('status-in-progress')
      expect(build(:lead, status: 'Завершена').status_class).to eq('status-completed')
    end
  end

  describe '.status_counts' do
    it 'returns counts by status' do
      create_list(:lead, 2, status: 'Новая')
      create(:lead, status: 'В работе')

      counts = Lead.status_counts
      expect(counts['Новая']).to eq(2)
      expect(counts['В работе']).to eq(1)
    end
  end
end
