# spec/admin/lead_spec.rb
require 'rails_helper'

RSpec.describe "ActiveAdmin Leads", type: :request do
  let(:admin_user) { create(:admin_user) }

  before do
    sign_in admin_user
  end

  describe "POST /admin/leads with invalid parameters" do
    it "returns unprocessable entity status" do
      post admin_leads_path, params: { lead: { name: '', email: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "shows validation errors" do
      post admin_leads_path, params: { lead: { name: '', email: 'invalid' } }
      expect(response.body).to include("Имя не может быть пустым")
      expect(response.body).to include("Неверный формат email")
    end
  end
end