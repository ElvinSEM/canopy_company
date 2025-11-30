# spec/services/lead_creator_spec.rb
require 'rails_helper'

RSpec.describe LeadCreator do
  describe '.create_lead' do
    let(:valid_attributes) do
      {
        name: 'Service Test Lead',
        email: 'service@example.com',
        phone: '+79991234567',
        message: 'Test message from service'
      }
    end

    it 'creates a new lead with valid attributes' do
      expect {
        LeadCreator.create_lead(valid_attributes)
      }.to change(Lead, :count).by(1)
    end

    it 'returns the created lead' do
      lead = LeadCreator.create_lead(valid_attributes)
      expect(lead).to be_persisted
      expect(lead.name).to eq('Service Test Lead')
      expect(lead.email).to eq('service@example.com')
    end

    it 'returns unsaved lead with errors for invalid attributes' do
      result = LeadCreator.create_lead(name: '', email: 'invalid')
      expect(result).not_to be_persisted
      expect(result.errors[:name]).to include("can't be blank")
      expect(result.errors[:email]).to include("is invalid")
    end

    it 'handles phone and message as optional' do
      lead = LeadCreator.create_lead(name: 'Test', email: 'test@example.com')
      expect(lead).to be_persisted
    end
  end

  describe '.create_lead!' do
    it 'creates lead and returns it' do
      lead = LeadCreator.create_lead!(
        name: 'Bang Test',
        email: 'bang@example.com'
      )
      expect(lead).to be_persisted
    end

    it 'raises exception for invalid attributes' do
      expect {
        LeadCreator.create_lead!(name: '', email: 'invalid')
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end