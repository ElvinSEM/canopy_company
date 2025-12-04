# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_FROM_EMAIL'] || 'from@example.com'
  layout 'mailer'
end