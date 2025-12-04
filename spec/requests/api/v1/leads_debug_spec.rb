# spec/requests/api/v1/leads_debug_spec.rb
require 'rails_helper'

RSpec.describe 'API Error Format Debug', type: :request do
  let!(:lead) { create(:lead) }

  it 'shows error format' do
    # Пробуем обновить с невалидным email
    put api_v1_lead_path(lead.id), params: {
      lead: { email: 'invalid-email' }
    }

    puts "Status: #{response.status}"
    puts "Response body: #{response.body}"
    puts "Parsed JSON: #{JSON.parse(response.body)}"
  end

  it 'shows error format for empty name' do
    put api_v1_lead_path(lead.id), params: {
      lead: { name: '' }
    }

    puts "Status: #{response.status}"
    puts "Response body: #{response.body}"
    puts "Parsed JSON: #{JSON.parse(response.body)}"
  end
end