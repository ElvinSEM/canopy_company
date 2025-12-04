# spec/factories/leads.rb
# FactoryBot.define do
#   factory :lead do
#     name { Faker::Name.name }
#     sequence(:email) { |n| "user#{n}@example.com" }
#     phone { Faker::PhoneNumber.phone_number }
#     message { Faker::Lorem.paragraph }
#     status { 'Новая' }
#
#     trait :new do
#       status { 'Новая' }
#     end
#
#     trait :in_progress do
#       status { 'В работе' }
#     end
#
#     trait :completed do
#       status { 'Завершена' }
#     end
#   end
#
# end