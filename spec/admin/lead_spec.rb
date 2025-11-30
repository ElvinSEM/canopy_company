# spec/admin/lead_spec.rb
require 'rails_helper'

RSpec.describe 'ActiveAdmin Lead', type: :feature do
  let(:admin_user) { create(:admin_user) }
  let!(:lead) { create(:lead) }

  before do
    login_as_admin(admin_user)
    visit admin_leads_path
  end

  describe 'index page' do
    it 'shows leads list' do
      expect(page).to have_content('Лиды')
      expect(page).to have_content(lead.name)
      expect(page).to have_content(lead.email)
    end

    it 'has status tags' do
      within '#index_table_leads' do
        expect(page).to have_css('.status_tag')
      end
    end

    it 'has action links' do
      within '#index_table_leads' do
        expect(page).to have_link('View')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Delete')
      end
    end
  end

  describe 'show page' do
    it 'displays lead details' do
      click_link 'View', href: admin_lead_path(lead)

      expect(page).to have_content(lead.name)
      expect(page).to have_content(lead.email)
      expect(page).to have_content(lead.phone) if lead.phone.present?
      expect(page).to have_content(lead.message) if lead.message.present?
    end

    it 'has back to list link' do
      click_link 'View', href: admin_lead_path(lead)
      expect(page).to have_link('Back to list')
    end
  end

  describe 'create new lead' do
    before do
      click_link 'New Lead'
    end

    it 'creates new lead with valid data' do
      fill_in 'Name', with: 'Новый Тестовый Лид'
      fill_in 'Email', with: 'new@example.com'
      fill_in 'Phone', with: '+79991234567'
      fill_in 'Message', with: 'Тестовое сообщение'
      select 'Новая', from: 'Status'

      click_button 'Create Lead'

      expect(page).to have_content('Lead was successfully created')
      expect(page).to have_content('Новый Тестовый Лид')
    end

    it 'shows errors with invalid data' do
      fill_in 'Name', with: ''
      fill_in 'Email', with: 'invalid-email'

      click_button 'Create Lead'

      expect(page).to have_content("can't be blank")
    end
  end

  describe 'edit lead' do
    it 'updates lead status' do
      click_link 'Edit', href: edit_admin_lead_path(lead)

      select 'В работе', from: 'Status'
      click_button 'Update Lead'

      expect(page).to have_content('Lead was successfully updated')
      expect(page).to have_content('В работе')
    end
  end

  describe 'filters' do
    it 'filters by status' do
      within '.filter_form' do
        select 'Новая', from: 'q_status_eq'
        click_button 'Filter'
      end

      expect(page).to have_content(lead.name)
    end
  end
end