# spec/requests/api/v1/leads_spec.rb (ПОЛНОСТЬЮ ИСПРАВЛЕННЫЙ)
require 'rails_helper'

RSpec.describe 'API V1 Leads', type: :request do
  let(:valid_attributes) do
    {
      lead: {
        name: 'API Test Lead',
        email: 'api@example.com',
        phone: '+79991234567',
        message: 'Test message from API',
        status: 'Новая'
      }
    }
  end

  let(:invalid_attributes) do
    {
      lead: {
        name: '',
        email: 'invalid-email'
      }
    }
  end

  let!(:lead) { create(:lead) }
  let(:lead_id) { lead.id }

  describe 'GET /api/v1/leads' do
    before { create_list(:lead, 3) }

    it 'returns all leads' do
      get api_v1_leads_path

      expect(response).to have_http_status(:success)
      expect(json_response.size).to eq(4) # 3 новых + 1 созданный ранее
    end

    it 'returns leads in JSON format' do
      get api_v1_leads_path

      expect(response.content_type).to include('application/json')
      expect(json_response.first).to have_key('id')
      expect(json_response.first).to have_key('name')
      expect(json_response.first).to have_key('email')
    end
  end

  describe 'GET /api/v1/leads/:id' do
    it 'returns a specific lead' do
      get api_v1_lead_path(lead_id)

      expect(response).to have_http_status(:success)
      expect(json_response['id']).to eq(lead_id)
      expect(json_response['name']).to eq(lead.name)
    end

    it 'returns 404 for non-existent lead' do
      get api_v1_lead_path(99999)

      expect(response).to have_http_status(:not_found)
      expect(json_response).to have_key('error')
    end
  end

  describe 'POST /api/v1/leads' do
    context 'with valid attributes' do
      it 'creates a new lead' do
        expect {
          post api_v1_leads_path, params: valid_attributes
        }.to change(Lead, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response['name']).to eq('API Test Lead')
        expect(json_response['email']).to eq('api@example.com')
      end
    end

    context 'with invalid attributes' do
      it 'does not create lead and returns errors' do
        expect {
          post api_v1_leads_path, params: invalid_attributes
        }.not_to change(Lead, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to have_key('errors')
        # Правильный формат: ["Field сообщение"]
        expect(json_response['errors']).to include('Name Имя не может быть пустым')
        expect(json_response['errors']).to include('Email Неверный формат email')
      end
    end
  end

  describe 'PUT /api/v1/leads/:id' do
    context 'with valid attributes' do
      it 'updates the lead' do
        put api_v1_lead_path(lead_id), params: {
          lead: { status: 'В работе' }
        }

        expect(response).to have_http_status(:success)
        lead.reload
        expect(lead.status).to eq('В работе')
      end

      it 'updates email with valid format' do
        put api_v1_lead_path(lead_id), params: {
          lead: { email: 'newvalid@example.com' }
        }

        expect(response).to have_http_status(:success)
        lead.reload
        expect(lead.email).to eq('newvalid@example.com')
      end
    end

    context 'with invalid attributes' do
      it 'returns validation errors for invalid email' do
        put api_v1_lead_path(lead_id), params: {
          lead: { email: 'invalid-email' }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to have_key('errors')
        # Правильный формат: ["Email Неверный формат email"]
        expect(json_response['errors']).to include('Email Неверный формат email')
      end

      it 'returns validation errors for empty name' do
        put api_v1_lead_path(lead_id), params: {
          lead: { name: '' }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to have_key('errors')
        # Правильный формат: ["Name Имя не может быть пустым"]
        expect(json_response['errors']).to include('Name Имя не может быть пустым')
      end

      it 'does not update the lead with invalid data' do
        original_email = lead.email

        put api_v1_lead_path(lead_id), params: {
          lead: { email: 'invalid-email' }
        }

        lead.reload
        expect(lead.email).to eq(original_email) # Email не должен измениться
      end
    end
  end

  describe 'PATCH /api/v1/leads/:id' do
    it 'allows partial updates' do
      patch api_v1_lead_path(lead_id), params: {
        lead: { phone: '+79998887766' }
      }

      expect(response).to have_http_status(:success)
      lead.reload
      expect(lead.phone).to eq('+79998887766')
    end

    it 'validates partial updates' do
      patch api_v1_lead_path(lead_id), params: {
        lead: { email: '' } # Пустой email
      }

      expect(response).to have_http_status(:unprocessable_entity)
      # Правильный формат: ["Email Email не может быть пустым"]
      expect(json_response['errors']).to include('Email Email не может быть пустым')
    end
  end

  describe 'DELETE /api/v1/leads/:id' do
    it 'deletes the lead' do
      expect {
        delete api_v1_lead_path(lead_id)
      }.to change(Lead, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'redirects to leads index' do
      delete api_v1_lead_path(lead_id)
      expect(response).to have_http_status(:no_content)
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end