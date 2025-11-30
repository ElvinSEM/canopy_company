# spec/requests/active_admin_debug_spec.rb
require 'rails_helper'

RSpec.describe 'ActiveAdmin Debug', type: :request do
  it 'tests basic routing' do
    get '/admin'
    puts "Status: #{response.status}"
    puts "Body snippet: #{response.body[0..500]}"
    puts "Location: #{response.location}"
  end

  it 'tests leads routing' do
    get '/admin/leads'
    puts "Status: #{response.status}"
    puts "Body snippet: #{response.body[0..500]}"
    puts "Location: #{response.location}"
  end
end