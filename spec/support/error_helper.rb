# spec/support/error_helper.rb
module ErrorHelper
  # Проверяет наличие ошибки в формате ["Field сообщение"]
  def expect_validation_error(field_name, message)
    expected_error = "#{field_name.capitalize} #{message}"
    expect(json_response['errors']).to include(expected_error)
  end

  # Проверяет что есть хотя бы одна ошибка
  def expect_any_validation_error
    expect(json_response['errors']).not_to be_empty
  end

  # Проверяет количество ошибок
  def expect_errors_count(count)
    expect(json_response['errors'].size).to eq(count)
  end
end

RSpec.configure do |config|
  config.include ErrorHelper, type: :request
end
