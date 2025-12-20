# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: 'Elvin@canopycompany.com'
  layout 'mailer'
end