# spec/system/leads_spec.rb
require 'rails_helper'

RSpec.describe 'Leads', type: :system do
  before do
    driven_by :rack_test
  end

  describe 'creating a new lead' do
    it 'allows user to submit lead form' do
      visit new_lead_path

      # Используем name атрибуты из формы
      fill_in 'lead[name]', with: 'System Test User'
      fill_in 'lead[email]', with: 'system@example.com'
      fill_in 'lead[phone]', with: '+79991234567'
      fill_in 'lead[message]', with: 'Test message from system test'

      # Находим кнопку по типу или тексту
      find('input[type="submit"]').click

      # Проверяем что lead создался
      expect(Lead.last.email).to eq('system@example.com')
      expect(Lead.last.name).to eq('System Test User')
    end

    it 'shows validation errors for invalid data' do
      visit new_lead_path

      fill_in 'lead[name]', with: ''
      fill_in 'lead[email]', with: 'invalid-email'
      find('input[type="submit"]').click

      # Проверяем что есть ошибки валидации
      expect(page).to have_content("can't be blank")
    end
  end

  describe 'root path' do
    it 'shows lead form' do
      visit root_path
      expect(page).to have_css('form')
    end
  end
end