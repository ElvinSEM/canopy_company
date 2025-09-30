class LeadMailer < ApplicationMailer
  default from: 'notifications@yourdomain.com'

  def new_lead(lead)
    @lead = lead
    mail(to: 'admin@yourdomain.com', subject: 'Новая заявка с сайта')
  end
end
