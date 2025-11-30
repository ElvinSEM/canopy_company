# spec/requests/active_admin_leads_spec.rb
require 'rails_helper'

RSpec.describe 'ActiveAdmin Leads Management', type: :request do
  let(:admin_user) { create(:admin_user) }

  before do
    # Мокаем методы аутентификации Active Admin
    allow_any_instance_of(ApplicationController).to receive(:authenticate_admin_user!).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_admin_user).and_return(admin_user)
  end

  describe 'GET /admin/leads' do
    it 'returns success status' do
      get admin_leads_path
      expect(response).to have_http_status(:success)
    end

    it 'displays leads list' do
      lead = create(:lead, name: 'Test Lead', email: 'test@example.com', status: 'Новая')
      get admin_leads_path

      expect(response.body).to include('Leads')
      expect(response.body).to include('Test Lead')
      expect(response.body).to include('test@example.com')
      expect(response.body).to include('Новая')
    end

    it 'has action links' do
      lead = create(:lead)
      get admin_leads_path

      expect(response.body).to include('View')
      expect(response.body).to include('Edit')
      expect(response.body).to include('Delete')
    end
  end

  describe 'GET /admin/leads/:id' do
    it 'shows lead details' do
      lead = create(:lead, name: 'Show Test', email: 'show@example.com', phone: '+79991234567')
      get admin_lead_path(lead)

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Show Test')
      expect(response.body).to include('show@example.com')
      expect(response.body).to include('+79991234567')
    end
  end

  describe 'GET /admin/leads/new' do
    it 'shows new lead form' do
      get new_admin_lead_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('New Lead')
    end
  end

  describe 'POST /admin/leads' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          lead: {
            name: 'New Admin Lead',
            email: 'newadmin@example.com',
            phone: '+79991234567',
            message: 'Test message from admin',
            status: 'В работе'
          }
        }
      end

      it 'creates a new lead' do
        expect {
          post admin_leads_path, params: valid_attributes
        }.to change(Lead, :count).by(1)
      end

      it 'redirects to the created lead' do
        post admin_leads_path, params: valid_attributes
        expect(response).to redirect_to(admin_lead_path(Lead.last))
      end

      it 'sets the correct attributes' do
        post admin_leads_path, params: valid_attributes
        lead = Lead.last

        expect(lead.name).to eq('New Admin Lead')
        expect(lead.email).to eq('newadmin@example.com')
        expect(lead.status).to eq('В работе')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          lead: {
            name: '',
            email: 'invalid-email'
          }
        }
      end

      it 'does not create a lead' do
        expect {
          post admin_leads_path, params: invalid_attributes
        }.not_to change(Lead, :count)
      end

      it 'returns unprocessable entity status' do
        post admin_leads_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'shows validation errors' do
        post admin_leads_path, params: invalid_attributes
        expect(response.body).to include('can&#39;t be blank')
      end
    end
  end

  describe 'PATCH /admin/leads/:id' do
    let(:lead) { create(:lead, status: 'Новая') }

    it 'updates lead status' do
      patch admin_lead_path(lead), params: {
        lead: { status: 'Завершена' }
      }

      expect(response).to redirect_to(admin_lead_path(lead))
      lead.reload
      expect(lead.status).to eq('Завершена')
    end

    it 'updates lead information' do
      patch admin_lead_path(lead), params: {
        lead: {
          name: 'Updated Name',
          phone: '+79998887766'
        }
      }

      lead.reload
      expect(lead.name).to eq('Updated Name')
      expect(lead.phone).to eq('+79998887766')
    end
  end

  describe 'DELETE /admin/leads/:id' do
    let!(:lead) { create(:lead) }

    it 'deletes the lead' do
      expect {
        delete admin_lead_path(lead)
      }.to change(Lead, :count).by(-1)
    end

    it 'redirects to leads index' do
      delete admin_lead_path(lead)
      expect(response).to redirect_to(admin_leads_path)
    end
  end
end