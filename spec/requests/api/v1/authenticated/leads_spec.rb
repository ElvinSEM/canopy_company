# # spec/requests/api/v1/authenticated/leads_spec.rb
# require 'rails_helper'
#
# RSpec.describe 'API V1 Leads with Authentication', type: :request do
#   let(:admin_user) { create(:admin_user) }
#   let(:token) { 'your-api-token-here' } # или JWT токен
#
#   before do
#     # Установка заголовков аутентификации
#     @headers = {
#       'Authorization' => "Bearer #{token}",
#       'Content-Type' => 'application/json'
#     }
#   end
#
#   describe 'GET /api/v1/leads' do
#     it 'requires authentication' do
#       get api_v1_leads_path
#       expect(response).to have_http_status(:unauthorized)
#     end
#
#     it 'returns leads when authenticated' do
#       create_list(:lead, 2)
#       get api_v1_leads_path, headers: @headers
#
#       expect(response).to have_http_status(:success)
#       expect(json_response.size).to eq(2)
#     end
#   end
# end