# spec/requests/active_admin_leads_spec.rb
require 'rails_helper'

RSpec.describe "ActiveAdmin Simple Leads management", type: :request do
  let(:admin_user) { create(:admin_user) }
  let(:lead) { create(:lead) }

  before do
    sign_in admin_user
  end

  it "can access leads index" do
    get admin_leads_path
    expect(response).to have_http_status(:success)
  end

  it "can view lead details" do
    get admin_lead_path(lead)
    expect(response).to have_http_status(:success)
  end

  it "can create new lead" do
    get new_admin_lead_path
    expect(response).to have_http_status(:success)

    post admin_leads_path, params: {
      lead: {
        name: "Новый лид",
        email: "test@example.com",
        phone: "+79991234567",
        status: "Новая"
      }
    }

    expect(response).to have_http_status(:redirect)
    follow_redirect!
    expect(response).to have_http_status(:success)
    expect(response.body).to include("Лид был успешно создан")
  end
end