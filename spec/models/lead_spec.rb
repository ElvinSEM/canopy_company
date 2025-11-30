# spec/models/lead_spec.rb
require 'rails_helper'

RSpec.describe Lead, type: :model do
  # Базовые тесты
  describe 'basic functionality' do
    it 'exists' do
      expect(described_class).to be_a(Class)
    end

    it 'has a valid factory' do
      expect(build(:lead)).to be_valid
    end

    it 'can be created with minimal attributes' do
      lead = Lead.new(name: 'Test', email: 'test@example.com')
      expect(lead).to be_valid
    end
  end

  # Валидации - ИСПРАВЛЕННАЯ ВЕРСИЯ
  describe 'validations' do
    # Для Shoulda Matchers создаем объект с валидными данными
    subject { build(:lead) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }

    it 'validates email format' do
      # Создаем валидный объект и меняем только email
      valid_lead = build(:lead)
      invalid_lead = build(:lead, email: 'invalid-email')

      expect(valid_lead).to be_valid
      expect(invalid_lead).not_to be_valid
      expect(invalid_lead.errors[:email]).to include('is invalid')
    end

    it 'validates status inclusion' do
      valid_lead = build(:lead, status: 'Новая')
      invalid_lead = build(:lead, status: 'invalid')

      expect(valid_lead).to be_valid
      expect(invalid_lead).not_to be_valid
      expect(invalid_lead.errors[:status]).to include('is not included in the list')
    end

    it 'allows optional phone' do
      lead_with_phone = build(:lead, phone: '+79991234567')
      lead_without_phone = build(:lead, phone: nil)

      expect(lead_with_phone).to be_valid
      expect(lead_without_phone).to be_valid
    end

    it 'allows optional message' do
      lead_with_message = build(:lead, message: 'Some message')
      lead_without_message = build(:lead, message: nil)

      expect(lead_with_message).to be_valid
      expect(lead_without_message).to be_valid
    end
  end

  # Scopes - ИСПРАВЛЕННАЯ ВЕРСИЯ
  describe 'scopes' do
    let!(:new_lead) { create(:lead, status: 'Новая') }
    let!(:in_progress_lead) { create(:lead, status: 'В работе') }
    let!(:completed_lead) { create(:lead, status: 'Завершена') }

    describe '.new_leads' do
      it 'returns only new leads' do
        new_leads = Lead.new_leads
        expect(new_leads).to include(new_lead)
        expect(new_leads).not_to include(in_progress_lead)
        expect(new_leads).not_to include(completed_lead)
      end
    end

    describe '.in_progress' do
      it 'returns only in progress leads' do
        in_progress_leads = Lead.in_progress
        expect(in_progress_leads).to include(in_progress_lead)
        expect(in_progress_leads).not_to include(new_lead)
        expect(in_progress_leads).not_to include(completed_lead)
      end
    end

    describe '.completed' do
      it 'returns only completed leads' do
        completed_leads = Lead.completed
        expect(completed_leads).to include(completed_lead)
        expect(completed_leads).not_to include(new_lead)
        expect(completed_leads).not_to include(in_progress_lead)
      end
    end

    describe '.recent' do
      before do
        Lead.destroy_all
        @old_lead = create(:lead, created_at: 1.hour.ago)
        @new_lead = create(:lead, created_at: 10.minutes.ago)
        @newest_lead = create(:lead, created_at: Time.current)
      end

      it 'returns limited number of leads' do
        expect(Lead.recent(2).count).to eq(2)
      end

      it 'orders by created_at desc (newest first)' do
        recent = Lead.recent(3)
        expect(recent.first).to eq(@newest_lead)  # Самый новый
        expect(recent.last).to eq(@old_lead)      # Самый старый
      end
    end
  end

  # Методы
  describe 'instance methods' do
    describe '#status_class' do
      it 'returns correct CSS classes' do
        expect(build(:lead, status: 'Новая').status_class).to eq('status-new')
        expect(build(:lead, status: 'В работе').status_class).to eq('status-in-progress')
        expect(build(:lead, status: 'Завершена').status_class).to eq('status-completed')
        expect(build(:lead, status: 'unknown').status_class).to eq('status-default')
      end
    end
  end

  describe 'class methods' do
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

  # Callbacks
  describe 'callbacks' do
    it 'sets default status on initialize' do
      lead = Lead.new(name: 'Test', email: 'test@example.com')
      expect(lead.status).to eq('Новая')
    end
  end
end