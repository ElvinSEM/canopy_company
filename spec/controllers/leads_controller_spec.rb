# spec/controllers/leads_controller_spec.rb
require 'rails_helper'

RSpec.describe LeadsController, type: :controller do
  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new lead' do
      get :new
      expect(assigns(:lead)).to be_a_new(Lead)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        name: 'Controller Test Lead',
        email: 'controller@example.com',
        phone: '+79991234567',
        message: 'Test message from controller'
      }
    end

    let(:invalid_attributes) do
      {
        name: '',
        email: 'invalid-email'
      }
    end

    context 'with valid attributes' do
      it 'creates a new lead' do
        expect {
          post :create, params: { lead: valid_attributes }
        }.to change(Lead, :count).by(1)
      end

      it 'redirects to root path after success' do
        post :create, params: { lead: valid_attributes }
        expect(response).to redirect_to(root_path)
      end

      it 'sets flash notice' do
        post :create, params: { lead: valid_attributes }
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new lead' do
        expect {
          post :create, params: { lead: invalid_attributes }
        }.not_to change(Lead, :count)
      end

      it 're-renders the new template' do
        post :create, params: { lead: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'assigns lead with errors' do
        post :create, params: { lead: invalid_attributes }
        expect(assigns(:lead).errors).to be_present
      end
    end
  end
end