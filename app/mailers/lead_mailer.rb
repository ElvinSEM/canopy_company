class LeadMailer < ApplicationMailer
  default from: ENV.fetch("DEFAULT_FROM_EMAIL", "no-reply@example.com")

  def new_lead_notification(lead)
    @lead = lead
    mail(
      to: ENV.fetch("ADMIN_EMAIL", "admin@example.com"),
      subject: "Новая заявка с сайта"
    )
  end

  def lead_status_updated(lead)
    @lead = lead
    mail(
      to: @lead.email,
      subject: "Статус вашей заявки обновлен"
    )
  end
end
