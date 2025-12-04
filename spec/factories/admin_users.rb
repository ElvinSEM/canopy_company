# spec/factories/admin_users.rb
FactoryBot.define do
  # factory :admin_user do
  #   sequence(:email) { |n| "admin#{n}@example.com" }
  #   password { 'password123' }
  #   password_confirmation { 'password123' }
  #
  #   trait :with_secure_password do
  #     password { 'SecurePassword123!' }
  #     password_confirmation { 'SecurePassword123!' }
  #   end
  # end

  factory :lead do
    name { "Тестовый лид" }
    email { "test@example.com" }
    phone { "+79991234567" }
    status { "Новая" }
  end
end