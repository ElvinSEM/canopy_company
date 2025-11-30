# spec/system/leads_form_debug_spec.rb
require 'rails_helper'

RSpec.describe 'Leads Form Structure', type: :system do
  it 'inspects form elements' do
    visit new_lead_path

    puts "=== FORM DEBUG INFO ==="
    puts "Current URL: #{current_url}"
    puts "Page title: #{page.title}"
    puts "Form action: #{page.find('form')[:action]}"

    puts "Form fields found:"
    page.all('input, textarea, select').each do |field|
      puts "  - #{field.tag_name}:"
      puts "     id: #{field[:id]}"
      puts "     name: #{field[:name]}"
      puts "     type: #{field[:type]}"
      puts "     placeholder: #{field[:placeholder]}"
    end

    puts "Buttons found:"
    page.all('button, input[type="submit"]').each do |button|
      puts "  - #{button.tag_name}:"
      puts "     type: #{button[:type]}"
      puts "     value: #{button[:value]}"
      puts "     text: #{button.text}"
    end
    puts "======================"
  end
end