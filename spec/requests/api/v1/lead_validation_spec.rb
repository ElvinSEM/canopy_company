# spec/requests/api/v1/lead_validation_spec.rb
require 'rails_helper'

RSpec.describe 'API V1 Lead Validations', type: :request do
  let!(:lead) { create(:lead) }

  describe 'email validation errors' do
    it 'returns error for empty email' do
      put api_v1_lead_path(lead.id), params: {
        lead: { email: '' }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['errors']).to include('Email Email не может быть пустым')
    end

    it 'returns error for invalid email format' do
      put api_v1_lead_path(lead.id), params: {
        lead: { email: 'not-an-email' }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['errors']).to include('Email Неверный формат email')
    end

    it 'returns error for email without @' do
      put api_v1_lead_path(lead.id), params: {
        lead: { email: 'emailwithoutat.com' }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['errors']).to include('Email Неверный формат email')
    end
  end

  describe 'name validation errors' do
    it 'returns error for empty name' do
      put api_v1_lead_path(lead.id), params: {
        lead: { name: '' }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['errors']).to include('Name Имя не может быть пустым')
    end
  end

  describe 'status validation errors' do
    it 'returns error for invalid status' do
      put api_v1_lead_path(lead.id), params: {
        lead: { status: 'Несуществующий статус' }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['errors']).to include(
                                           'Status Статус должен быть одним из: Новая, В работе, Завершена'
                                         )
    end
  end
end